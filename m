Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab3BZIbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:31:13 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4680 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3BZIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:31:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [PATCH v5 0/8] Driver for Si476x series of chips
Date: Tue, 26 Feb 2013 09:30:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302260930.07222.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue February 26 2013 07:38:46 Andrey Smirnov wrote:
> This is a fourth version of the patchset originaly posted here:
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
> v5 of this driver has following changes:
> - Generic controls are converted to standard ones
> - Custom controls use a differend offest as base
> - Added documentation with controls description

Reviewed this. Found some small stuff, although I need a bit more info
regarding the diversity mode (see my question in the review of patch 8/8).

Depending on that you can likely make a v6 which I can ack.

Regards,

	Hans

> 
> 
> Andrey Smirnov (8):
>   mfd: Add header files and Kbuild plumbing for SI476x MFD core
>   mfd: Add commands abstraction layer for SI476X MFD
>   mfd: Add the main bulk of core driver for SI476x code
>   mfd: Add chip properties handling code for SI476X MFD
>   v4l2: Add standard controls for FM receivers
>   v4l2: Add documentation for the FM RX controls
>   v4l2: Add private controls base for SI476X
>   v4l2: Add a V4L2 driver for SI476X MFD
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/controls.xml       |   72 +
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   11 +-
>  Documentation/video4linux/si476x.txt               |  187 +++
>  drivers/media/radio/Kconfig                        |   17 +
>  drivers/media/radio/Makefile                       |    1 +
>  drivers/media/radio/radio-si476x.c                 | 1581 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               |   14 +-
>  drivers/mfd/Kconfig                                |   13 +
>  drivers/mfd/Makefile                               |    4 +
>  drivers/mfd/si476x-cmd.c                           | 1553 +++++++++++++++++++
>  drivers/mfd/si476x-i2c.c                           |  878 +++++++++++
>  drivers/mfd/si476x-prop.c                          |  234 +++
>  include/linux/mfd/si476x-core.h                    |  525 +++++++
>  include/media/si476x.h                             |  426 ++++++
>  include/uapi/linux/v4l2-controls.h                 |   17 +-
>  16 files changed, 5531 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/video4linux/si476x.txt
>  create mode 100644 drivers/media/radio/radio-si476x.c
>  create mode 100644 drivers/mfd/si476x-cmd.c
>  create mode 100644 drivers/mfd/si476x-i2c.c
>  create mode 100644 drivers/mfd/si476x-prop.c
>  create mode 100644 include/linux/mfd/si476x-core.h
>  create mode 100644 include/media/si476x.h
> 
> 
