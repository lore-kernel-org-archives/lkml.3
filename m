Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3BSFG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:06:28 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4030 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3BSFG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:06:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [PATCH v4 0/7] Driver for Si476x series of chips
Date: Mon, 18 Feb 2013 21:05:19 -0800
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-prime; KDE/4.8.4; x86_64; ; )
Cc: broonie@opensource.wolfsonmicro.com, mchehab@redhat.com,
        sameo@linux.intel.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302182105.20090.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 18, 2013 19:59:28 Andrey Smirnov wrote:
> This is a fourth version of the patchset originaly posted here:
> https://lkml.org/lkml/2012/9/13/590
> 
> Second version of the patch was posted here:
> https://lkml.org/lkml/2012/10/5/598
> 
> Third version of the patch was posted here:
> https://lkml.org/lkml/2012/10/23/510
> 
> To save everyone's time I'll repost the original description of it:
> 
> This patchset contains a driver for a Silicon Laboratories 476x series
> of radio tuners. The driver itself is implemented as an MFD devices
> comprised of three parts: 
>  1. Core device that provides all the other devices with basic
> functionality and locking scheme.
>  2. Radio device that translates between V4L2 subsystem requests into
> Core device commands.
>  3. Codec device that does similar to the earlier described task, but
> for ALSA SoC subsystem.
> 
> v4 of this driver has following changes:
>  - All of the adjustable timeouts(expose via sysfs) are gone
>  - Names of the controls are changes as was requested
>  - Added documentation for exposed debugfs files 
>  - Minor fix in si476x_radio_fops_poll
>  - DBG_BUFFER is removed
>  - Tested for compilation w/o debugfs enabled
> 
> This version still has all the radio controls being private. The
> reason for that is because I am not sure how that should be handled.
> 
> Hans, do you want me to move all the controls to be standard, that is
> exted V4L's with the needed controls? Should I pick up the parts of
> http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html and take relevants bits and pieces of it?

Yes, please do that. It's too bad that never made it into the kernel, so let's
do it now.

So take the controls that you can use from that patch and leave out those that
do not apply to your driver. From the remaining controls not covered by that
patch you will have to decide which are truly chip-specific and which are
valid for any advanced radio receiver.

The really chip(set) specific controls should be put in their own header,
but add the base control ID to v4l2-controls.h (see for example the way that
is done for the MEYE controls).

If you can do that quickly and post a v5, then I will do my best to review
it this week or Monday at the latest. Let's finish this driver asap.

Regards,

	Hans
