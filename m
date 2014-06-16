Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaFPVOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:14:12 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:57106 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaFPVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:14:11 -0400
Date: Mon, 16 Jun 2014 23:14:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        linux-kbuild@vger.kernel.org, x86-ml <x86@kernel.org>
Subject: Re: [RFC] Turn off -Wmaybe-uninitialized completely and move it to
 W=1
Message-ID: <20140616211405.GA7914@ravnborg.org>
References: <20140616132045.GE8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616132045.GE8170@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:20:45PM +0200, Borislav Petkov wrote:
> Hi,
> 
> so 3.16-rc1 adds this false positive from gcc, see below (triggers on
> 4.9 and 4.8.2). Now, it is firing wrong and gcc people tell me there's
> no way for the compiler to know that the "from" and "to" values will NOT
> be used in the error case, i.e. thus the "maybe" aspect.
> 
> So, we've disabled it for -Os already:
> 
> 	e74fc973b6e5 ("Turn off -Wmaybe-uninitialized when building with -Os")
> 
> maybe we want to disable it by default on all and move it to W=1. This
> way people can still have it fire but not by default. And from what I've
> seen so far, it is mostly firing wrong and it is becoming annoying.
> 
> So what do people think, any reasons for keeping it enabled by default?
Agreed.
The noise ratio is too high - so move it to W=1.

	Sam
