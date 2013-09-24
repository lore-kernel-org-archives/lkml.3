Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3IXLeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 07:34:31 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37463 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3IXLea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 07:34:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "open list:USB VIDEO CLASS" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default on uvcvideo"
Date: Tue, 24 Sep 2013 13:34:36 +0200
Message-ID: <1657156.ZjLeh8FSxj@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130613095647.GC21583@adam-laptop>
References: <1366790239-838-1-git-send-email-adam.lee@canonical.com> <20130425063306.GA20928@adam-laptop> <20130613095647.GC21583@adam-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On Thursday 13 June 2013 17:56:47 Adam Lee wrote:
> On Thu, Apr 25, 2013 at 02:33:06PM +0800, Adam Lee wrote:
> > On Wed, Apr 24, 2013 at 11:17:52AM +0200, Laurent Pinchart wrote:
> > > On Wednesday 24 April 2013 15:57:19 adam.lee@canonical.com wrote:
> > > > From: Adam Lee <adam.lee@canonical.com>
> > > > 
> > > > This reverts commit 3dae8b41dc5651f8eb22cf310e8b116480ba25b7.
> > > > 
> > > > 1, I do have a Chicony webcam, implements autosuspend in a broken way,
> > > > make `poweroff` performs rebooting when its autosuspend enabled.
> > > > 
> > > > 2, There are other webcams which don't support autosuspend too, like
> > > > https://patchwork.kernel.org/patch/2356141/
> > > > 
> > > > 3, kernel removed USB_QUIRK_NO_AUTOSUSPEND in
> > > > a691efa9888e71232dfb4088fb8a8304ffc7b0f9, because autosuspend is
> > > > disabled by default.
> > > > 
> > > > So, we need to disable autosuspend in uvcvideo, maintaining a quirk
> > > > list only for uvcvideo is not a good idea.
> > > 
> > > I've received very few bug reports about broken auto-suspend support in
> > > UVC devices. Most of them could be solved by setting the RESET_RESUME
> > > quirk in USB core, only the Creative Live! Cam Optia AF required a quirk
> > > in the uvcvideo driver. I would thus rather use the available quirks
> > > (USB_QUIRK_RESET_RESUME if possible, UVC_QUIRK_DISABLE_AUTOSUSPEND
> > > otherwise) than killing power management for the vast majority of
> > > webcams that behave correctly.
> >
> > Here comes another one, integrated Chicony webcam 04f2:b39f, its
> > autosuspend makes `poweroff` performs rebooting at the laptop I'm working
> > on.

That's a pretty bad one :-/ Do you have any idea why it occurs ?

> > I tried USB_QUIRK_RESET_RESUME, not helping.
> > 
> > The quirks list will go longer and longer absolutely, do uvcvideo wanna
> > maintain that? And why only uvcvideo do this in kernel space which
> > against general USB module?
> > 
> > I still suggest we disable it by default, people can enable it in udev
> > just like almost all distroes do for udisks. Please consider about it.
> 
> Any comment of this? I still think it's a risk to enable autosuspend in
> uvcvideo by default, there must be users meeting weird issues but didn't
> report to you becaue they didn't figured out the cause.

I've discussed this issue during LPC last week, and I still believe we should 
enable auto-suspend. The feature really saves power, without it my C910 
Logitech webcam gets hot even when unused. 

If we disable auto-suspend by default and enable it from userspace only a 
handful of devices will get auto-suspended. Unless we can get distros to 
automatically test auto-suspend on unknown webcam models and report the 
results to update a central data base (which would grow much bigger than a 
quirks list in the driver in my opinion), disabling auto-suspend would be a 
serious regression.

Any comment from other developers from the mailing lists ?

-- 
Regards,

Laurent Pinchart

