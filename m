Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967341Ab3DRR2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:28:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935970Ab3DRR2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:28:08 -0400
Date: Thu, 18 Apr 2013 14:28:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: sameo@linux.intel.com, hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/12]  Driver for Si476x series of chips
Message-ID: <20130418142800.5c00b004@redhat.com>
In-Reply-To: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 18 Apr 2013 09:58:26 -0700
Andrey Smirnov <andrew.smirnov@gmail.com> escreveu:

> Driver for Si476x series of chips
> 
> This is a eight version of the patchset originaly posted here:
> https://lkml.org/lkml/2012/9/13/590
> 
> Second version of the patch was posted here:
> https://lkml.org/lkml/2012/10/5/598
> 
> Third version of the patch was posted here:
> https://lkml.org/lkml/2012/10/23/510
> 
> Fourth version of the patch was posted here:
> https://lkml.org/lkml/2013/2/18/572
> 
> Fifth version of the patch was posted here:
> https://lkml.org/lkml/2013/2/26/45
> 
> Sixth version of the patch was posted here:
> https://lkml.org/lkml/2013/2/26/257
> 
> Seventh version of the patch was posted here:
> https://lkml.org/lkml/2013/2/27/22
> 
> Eighth version of the patch was posted here:
> https://lkml.org/lkml/2013/3/26/891
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
> v9 of this driver has following changes:
>    - MFD part of the driver no longer depends on the header file added
>      by the radio driver(media/si476x.h) which should potential
>      restore the bisectability of the patches
> 
> Mauro, I am not sure if you reverted changes in patches 5 - 7, so I am
> including them just in case.

No, I didn't revert all patches. I just reverted two patches: the
last one, and the one that Samuel asked me.

Please rebase the remaining drivers/media patch(es) on the top of my tree,
or on the top of linux-next.

Regards,
Mauro

> 
> Hans, some of the patches you gave your ACK to were changed, but since
> the only thing changed is the location of the original code(it was
> rearranged into different files) I did not remove your ACKs from the
> new commits. I hope you don't mind, but if you do, let me know and
> I'll post an updated version of the patchset so it would be clear that
> it is not ready to be merged.
> 
> Please note, taht patch #12 is the modified version of
> https://patchwork-mail.kernel.org/patch/2420751/ 
> It _was not_ ACKEd by anyone.
> 
> Samuel, I couldn't just move media/si476x.h to mfd patches because it
> would also break bisectability since media/si476x.h depends on patch
> #8 in this patchset(whcih is the change that should go through 'media' tree)
> But I rearranged definitions and there shouldn't be any dependencies on
> media patches in MFD part.
> 
> Andrey Smirnov (10):
>   mfd: Add commands abstraction layer for SI476X MFD
>   mfd: Add the main bulk of core driver for SI476x code
>   mfd: Add chip properties handling code for SI476X MFD
>   mfd: Add header files and Kbuild plumbing for SI476x MFD core
>   v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
>   v4l2: Add standard controls for FM receivers
>   v4l2: Add documentation for the FM RX controls
>   v4l2: Add private controls base for SI476X
>   v4l2: Add a V4L2 driver for SI476X MFD
>   radio-si476x: Fix incorrect pointer checking
> 
> Hans Verkuil (1):
>   si476x: Fix some config dependencies and a compile warnings
> 
> Mauro Carvalho Chehab (1):
>   radio-si476x: vidioc_s* now uses a const parameter
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/controls.xml       |   74 +-
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    9 +
>  Documentation/video4linux/si476x.txt               |  187 +++
>  drivers/media/radio/Kconfig                        |   17 +
>  drivers/media/radio/Makefile                       |    1 +
>  drivers/media/radio/radio-si476x.c                 | 1575 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               |   14 +-
>  drivers/mfd/Kconfig                                |   13 +
>  drivers/mfd/Makefile                               |    4 +
>  drivers/mfd/si476x-cmd.c                           | 1553 +++++++++++++++++++
>  drivers/mfd/si476x-i2c.c                           |  886 +++++++++++
>  drivers/mfd/si476x-prop.c                          |  242 +++
>  include/linux/mfd/si476x-core.h                    |  533 +++++++
>  include/linux/mfd/si476x-platform.h                |  267 ++++
>  include/linux/mfd/si476x-reports.h                 |  163 ++
>  include/media/si476x.h                             |   37 +
>  include/uapi/linux/v4l2-controls.h                 |   17 +
>  18 files changed, 5591 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/video4linux/si476x.txt
>  create mode 100644 drivers/media/radio/radio-si476x.c
>  create mode 100644 drivers/mfd/si476x-cmd.c
>  create mode 100644 drivers/mfd/si476x-i2c.c
>  create mode 100644 drivers/mfd/si476x-prop.c
>  create mode 100644 include/linux/mfd/si476x-core.h
>  create mode 100644 include/linux/mfd/si476x-platform.h
>  create mode 100644 include/linux/mfd/si476x-reports.h
>  create mode 100644 include/media/si476x.h
> 


-- 

Cheers,
Mauro
