Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3FQMa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:30:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46347 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995Ab3FQMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:30:56 -0400
Date: Mon, 17 Jun 2013 13:30:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Zach Bobroff <zacharyb@ami.com>, Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <JLee@suse.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Message-ID: <20130617123052.GE8569@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun, at 12:02:05PM, Jan Beulich wrote:
> >>> On 17.06.13 at 12:17, Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > What value would you suggest for the retry?
> 
> I'd be considering something like 5...10, but this to some degree
> depends on what odd kinds of behavior this in fact needs to
> cover.

I genuinely don't see how picking numbers (seemingly) at random is an
improvement over the simple case of "if ExitBootServices() returns an
error, you get one more try". Unless you're aware of firmware that
requires calling ExitBootServices() multiple times? The grub ChangeLog
that Joey linked to is not particularly enlightening.

The scenario that this patch addresses is a very clear one, where the
firmware event handlers that respond to the initial ExitBootServices
event allocate/free memory, thereby invalidating the memory map cookie
we passed to ExitBootServices(), and requiring us to call
ExitBootServices() a second time. 

I'm not saying that retrying once is the only solution that will ever
make sense. But certainly until we start seeing reports of problems and
understand why firmware might want us to invoke ExitBootServices()
multiple times, it seems like the most straight forward option.

-- 
Matt Fleming, Intel Open Source Technology Center
