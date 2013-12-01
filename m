Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3LADoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 22:44:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3LADoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 22:44:05 -0500
Date: Sat, 30 Nov 2013 19:45:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, omar.ramirez@copitl.com,
        tony@atomide.com, felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com,
        ohad@wizery.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a
 security problem
Message-ID: <20131201034501.GA10803@kroah.com>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130191931.GA5286@amd.pavel.ucw.cz>
 <20131130194935.GG5443@mwanda>
 <20131130204237.GA17912@amd.pavel.ucw.cz>
 <20131130220553.GA1901@kroah.com>
 <20131130225822.GA26031@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130225822.GA26031@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 11:58:23PM +0100, Pavel Machek wrote:
> On Sat 2013-11-30 14:05:53, Greg KH wrote:
> > On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek wrote:
> > > 
> > > mmap in tidspbridge is missing range-checks. For now, make this
> > > interface root-only, so that it does not cause security problems.
> > 
> > Please fix this properly and don't paper over the real problem here.
> 
> Well, if the driver is left uncompilable, I'm pretty sure it will
> bitrot.
> 
> I do have the hardware, but I'm pretty sure current mailine does not
> have enough support to boot Maemo, so it is non trivial for me to test
> changes here.
> 
> And yes, I'd like to get N900 to better shape, but there's more urgent
> work to do there. Such as "make sure N900 still boots once omap moves away
> from device files".
> 
> [It seems like check should be that
> 
> vma->vm_pgoff << PAGE_SHIFT >= pdata->phys_mempool_base and 
> vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT - pdata->phys_mempool_base) <= pdata->phys_mempool_size .
> 
> But... this is some kind of DSP coprocessor, and I am not sure if
> just exposing its address space to untrusted processes is good idea.
> 
> Heck, are you sure this is security problem in the first place? Yes,
> it is unchecked mmap. So what? If the device is 600 root.root, and if
> the DSP can take over main system, 
> 
>         if (!capable(CAP_SYS_RAWIO))
>                 return -EPERM;

Will that break userspace?  Who opens and mmaps this device?  If you
don't know if users do this, how can you say this patch isn't going to
break things just as much as not having the driver there at all?

thanks,

greg k-h
