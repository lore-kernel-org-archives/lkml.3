Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3HPPsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:48:24 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60979 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3HPPsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:48:17 -0400
Date: Fri, 16 Aug 2013 10:48:16 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PULL] Miscellaneous trivialities
To: Michael Witten <mfwitten@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com>
In-Reply-To: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com> (from
	mfwitten@gmail.com on Thu Aug 15 04:44:01 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1376668096.2737.43@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 04:44:01 AM, Michael Witten wrote:
> I've been sitting on some trivial patches for a while, and I'd just
> like to get them out of the way.
> 
> Here is the series:
> 
>   [1] Docs: Kconfig: For readability, offset modifiers with commas
>   [2] Docs: Kconfig: Use consistent whitespace indentation
>   [3] Docs: Kconfig: Clean up the radiotap documentation
>   [4] Docs: Kconfig: `devlopers' -> `developers'
>   [5] Docs: Replace `hotplug' with `udev'
>   [6] DRM: comment: halve -> half
>   [7] DRM: comment: gdm_proc_lists -> drm_proc_lists
>   [8] DRM: cleanup: Remove unused `gamma_size'
> 
>   Documentation/networking/README.ipw2200 |   5 +-
>   drivers/gpu/drm/drm_fb_helper.c         |   3 -
>   drivers/gpu/drm/drm_irq.c               |   4 +-
>   drivers/gpu/drm/drm_proc.c              |   2 +-
>   drivers/net/wireless/ipw2x00/Kconfig    | 102  
> ++++++++++++++++----------------
>   fs/btrfs/Kconfig                        |   3 +-
>   init/Kconfig                            |   4 +-
>   7 files changed, 60 insertions(+), 63 deletions(-)
> 
> Those commits merge cleanly with:
> 
>   28fbc8b6a29c849a3f03a6b05010d4b584055665
>   Merge branch 'sched-urgent-for-linus' of
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>     (2013-08-13 16:58:17 -0700)
> 
> and they can be pulled from here:
> 
>   https://github.com/mfwitten/linux.git trivial/misc/0
> 
> While it is much easier to review the individual commits, a combined
> diff is appended to the end of this email in case that is convenient.
> 
> Sincerely
> Michael Witten
> 
> ----------------------------------------------------------------
> 
> diff --git a/Documentation/networking/README.ipw2200  
> b/Documentation/networking/README.ipw2200
> index b7658be..aeb6494 100644
> --- a/Documentation/networking/README.ipw2200
> +++ b/Documentation/networking/README.ipw2200
> @@ -256,7 +256,7 @@ You can set the debug level via:
> 
>  Where $VALUE would be a number in the case of this sysfs entry.  The
>  input to sysfs files does not have to be a number.  For example, the
> -firmware loader used by hotplug utilizes sysfs entries for  
> transferring
> +firmware loader used by udev utilizes sysfs entries for transferring
>  the firmware image from user space into the driver.

Hotplug is the name of the kernel subsystem, udev was one  
implementation of a userspace agent for it. A different implementation  
would be mdev (in busybox), some linux from scratch types are still  
using variants of diethotplug, there's a fork of udev called eudev that  
avoids systemd...

And these days, firmware loading is mostly done directly by the kernel.

>  The Intel(R) PRO/Wireless 2915ABG Driver for Linux exposes sysfs  
> entries
> @@ -425,8 +425,7 @@ are made to the driver.  Currently, there are no  
> major changes planned.
>  ----------------------------------------------
> 
>  The driver requires a firmware image, download it and extract the
> -files under /lib/firmware (or wherever your hotplug's firmware.agent
> -will look for firmware files)
> +files under /lib/firmware (or wherever udev will look for firmware  
> files)

Again, hotplug is correct.

Rob