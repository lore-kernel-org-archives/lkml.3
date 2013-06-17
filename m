Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3FQKRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:17:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34364 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313Ab3FQKRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:17:48 -0400
Date: Mon, 17 Jun 2013 11:17:45 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Joey Lee <JLee@suse.com>, Zach Bobroff <zacharyb@ami.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Message-ID: <20130617101745.GB8569@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEF71402000078000DEC12@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun, at 10:46:28AM, Jan Beulich wrote:
> To me, all this looks like it is being done on phenomenological basis,
> taking a particular build of a particular firmware implementation as
> the reference. Imo we shouldn't change the code in this way. This
> also applies to the fact that the step is being doubled rather than
> e.g. tripled: With it ending up a "again" anyway (see below), what's
> the point of avoiding one more of the iterations?
> 
> Generic considerations would result in the increment being at least
> 3 * element size; twice the element size assumes that the allocator
> would behave in certain ways (like returning the head or tail part of
> a larger piece of memory).
 
I have no issue with changing the multiplier. But let's get
clarification from Zach as to what exactly is going on here.

> I agree that there ought to be an upper limit. But a single retry here
> again looks like a tailored solution to a particular observed (mis-)
> behavior, rather than something resulting from general considerations.

What value would you suggest for the retry?

-- 
Matt Fleming, Intel Open Source Technology Center
