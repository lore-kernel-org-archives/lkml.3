Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3FLMht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:37:49 -0400
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:35446 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402Ab3FLMhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:37:47 -0400
Date: Wed, 12 Jun 2013 14:08:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume
 functions
Message-ID: <20130612120821.GD305@game.jcrosoft.org>
References: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
 <1944274.r5ID26zhWd@wuerfel>
 <20130610163134.1c4124abba64c5f7099cb4ff@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610163134.1c4124abba64c5f7099cb4ff@linux-foundation.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7323978894262971380
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:31 Mon 10 Jun     , Andrew Morton wrote:
> On Fri, 07 Jun 2013 12:02:31 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Friday 07 June 2013 10:39:20 Jingoo Han wrote:
> > > Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
> > > build warning when CONFIG_PM_SLEEP is not selected. This is because
> > > sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
> > > the CONFIG_PM_SLEEP is enabled.
> > > 
> > > drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
> > > drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]
> > > 
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > ---
> > >  drivers/video/backlight/backlight.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > 
> > Your patch looks ok, but I find it extremely annoying to have new warnings
> > like this one come up every single day in linux-next. It really shouldn't
> > be this hard to use a macro called SIMPLE_DEV_PM_OPS() correctly.
> > 
> > Below is an implementation of SIMPLE_DEV_PM_OPS and UNIVERSAL_DEV_PM_OPS
> > that avoids this issue by introducing an unused reference to the suspend
> > and resume functions. gcc is smart enough to leave out that unused code
> > by itself, and it would actually improve compile-time coverage to have
> > something like this, besides being harder to misuse.
> > 
> > This would be a better approach if we didn't already have all the "#ifdef
> > CONFIG_PM_SLEEP" in place that hide the functions now. Unfortunately we
> > already have over 300 uses of SIMPLE_DEV_PM_OPS/UNIVERSAL_DEV_PM_OPS
> > in the kernel today, so removing all the #ifdef atomically without
> > creating more build errors is rather hard to do.
> > 
> > Maybe someone has an idea how to extend my approach so it works with
> > and without the #ifdef, to let us transition to a situation that no
> > longer needs them.
> 
> You could create new macros, and add a checkpatch rule to remind people
> to not use the old ones.  Then people can migrate over from the old
> macros at a leisurely pace.
> 
> The problem will be in thinking up decent names for the new macros.

Agreed

Best Regards,
J.
