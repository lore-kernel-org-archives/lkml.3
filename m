Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3FFV2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:28:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3FFV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:27:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH v3] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Thu, 06 Jun 2013 23:27:47 +0200
Message-ID: <5441622.ypFXsKluBt@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <001a01ce6010$3daaf3c0$b900db40$@samsung.com>
References: <1370128047-2444-1-git-send-email-shuah.kh@samsung.com> <001a01ce6010$3daaf3c0$b900db40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IFryPWX3D/4SuQYH8HBD+etO0Y4dPwjvnLwoJeHwN7k
 psWDGyxkjgzDb+LKOEa0+kVRa4pl/4YjEJgrbLiUSgBhybRJPW
 zcbYMHmosiEX7RDPUm6y/oXlfHcCUEeFJBPx/xoxnzaAz/E5TW
 mnIqqvXvhtdI8mLDEBcQgif3OFaeB0ch36boUTp7uNrWWCQ0L9
 acMqLx+qaQVqf7KA2bjxF3d2S+DTY+EiTolnWd6ZY7sY8Q7Nbc
 lN3X7b1oVr/DG9yDpJ/EMIm7HFCCkxjVClIv7KEP8ODqt2hywV
 O5KV2VpLVSbWjjmZsKPy5VPRfLz1QL4zLYwNGQbavIZh5p49Z9
 8f174i0YyqGdrAOLfbAQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 13:10:10 Jingoo Han wrote:
> On Sunday, June 02, 2013 8:07 AM, Shuah Khan wrote:
> > 
> > Convert drivers/video/backlight/class to use dev_pm_ops for power
> > management and remove Legacy PM ops hooks. With this change, backlight
> > class registers suspend/resume callbacks via class->pm (dev_pm_ops)
> > instead of Legacy class->suspend/resume. When __device_suspend() runs
> > call-backs, it will find class->pm ops for the backlight class.
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > Cc: Shuah Khan <shuahkhan@gmail.com>
> 
> CC'ed Andrew Morton,
> 
> It looks good.
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 

I'm getting this build warning now:

arnd@wuerfel:/git/arm-soc$ cat build/omap1_defconfig/faillog 
/git/arm-soc/drivers/video/backlight/backlight.c:212:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
 static int backlight_suspend(struct device *dev)
            ^
/git/arm-soc/drivers/video/backlight/backlight.c:226:12: warning: 'backlight_resume' defined but not used [-Wunused-function]
 static int backlight_resume(struct device *dev)

	Arnd
