Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaAQQxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:53:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaAQQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:53:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 3/3] power: reset: use syscon driver to parse reboot register from scu
Date: Fri, 17 Jan 2014 17:52:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Feng Kan <fkan@apm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1389748055-23534-1-git-send-email-fkan@apm.com> <1389748055-23534-4-git-send-email-fkan@apm.com>
In-Reply-To: <1389748055-23534-4-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171752.47393.arnd@arndb.de>
X-Provags-ID: V02:K0:Xkn0L5yZVTo99Zz8+IK7M5KRMWpGclMl5HUt4UC3qfC
 4FbSK9fOzDd/Qv8FA2xRz/A9LHINO+Wd6ds01+z2umQP7rjFUh
 /EGr/xxSosWxPdxFVSzKGAXNZDtKT8yFLingTULgEcwt7Qgia3
 k+57ZdCeUkGHXYrPoIldbsdvCWppYM+VV/eB9+b0GM3ylPeVWu
 SmYSjg17QqC2Hdvcm9L89L8yFOZHPdnsAfjPBps+grYLNeb1Jp
 SEnkt6RAejkA9D+pjsbbr/ucJWkvsmIai82JM9NnYFpnr63jUa
 X5wA+zDn8MMTzoFV1ZQEHk01lS/DcR0r+nkANG8W+OOxutpKvv
 b41PIRoy7ZsABla8R+zU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Feng Kan wrote:
> +static int __init xgene_reboot_init(void)
>  {
>         arm_pm_restart = xgene_restart;
>         return 0;
>  }
>  device_initcall(xgene_reboot_init);

This won't work on a generic kernel, since you unconditionally set the
pm_restart function to your own, which is broken for everything else.

Please keep the platform_driver to attach to the reboot device
as you had before. It might be good to turn this into a generic
"syscon-reset" driver that gets both the register number and
the contents to write from the device node.

	Arnd
