Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3KMLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:21:31 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44395 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758646Ab3KMLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:21:26 -0500
Date: Wed, 13 Nov 2013 11:21:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries
 to nvram.
Message-ID: <20131113112052.GJ22636@console-pimps.org>
References: <87fvr3h3b9.fsf@redhat.com>
 <20131111110701.GE22636@console-pimps.org>
 <87eh6nt8oo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh6nt8oo.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov, at 08:38:31PM, Madper Xie wrote:
> 
> matt@console-pimps.org writes:
> 
> > On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
> >> Howdy all,
> >>   For now we ensure at least ~5kb free space. But my dell xps still
> >>   become a brick after I add too many entries to my nvram. So maybe 5kb
> >>   is not safe enough. and 5kb is just aginst Samsung's laptop.
> >>   So should we enlarge EFI_MIN_RESERVE?
> >
> > Urgh.............
> >
> > Thanks for the report. Could you provide some more details?
> >
> >  - Is your machine definitely bricked?
> Yes, pretty sure. After I press power button, the screen shows "DELL"
> and hangs. I can't step into any configure interface and the keyboard is
> dead. (NumLock led on, and I can't turn it off.) Of course my kernel
> won't be loaded. The only way to fix it is change the jump line which is
> on the motherboard.

OK, that's pretty conclusive. Thanks.

> >  - Have you got a dmesg from the machine before it broke?
> No. But with a diagnostic kernel(without change the behavior of
> efi. Simply print total size and remain size when I write something to
> nvram. Provided by Lenny), I got following output:
 
Have you been able to calculate the safe limit of NVRAM we need to
reserve to avoid bricking your machine?

I was interested in the DMI and other firmware strings from dmesg.

-- 
Matt Fleming, Intel Open Source Technology Center
