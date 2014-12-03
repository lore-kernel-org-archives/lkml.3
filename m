Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaLCFzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:55:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42591 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCFzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:55:07 -0500
Date: Tue, 2 Dec 2014 21:54:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-input@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ferruh Yigit <fery@cypress.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] input / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Message-ID: <20141203055444.GA7411@dtor-glaptop>
References: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8119438.MdkFLx3Wvh@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 03:09:10AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes in 2 files under drivers/input/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Yeah, it should be fine.

> 
> ---
>  drivers/input/keyboard/samsung-keypad.c  |    2 +-
>  drivers/input/touchscreen/cyttsp4_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/input/keyboard/samsung-keypad.c
> ===================================================================
> --- linux-pm.orig/drivers/input/keyboard/samsung-keypad.c
> +++ linux-pm/drivers/input/keyboard/samsung-keypad.c
> @@ -463,7 +463,7 @@ static int samsung_keypad_remove(struct
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int samsung_keypad_runtime_suspend(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> Index: linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> ===================================================================
> --- linux-pm.orig/drivers/input/touchscreen/cyttsp4_core.c
> +++ linux-pm/drivers/input/touchscreen/cyttsp4_core.c
> @@ -1716,7 +1716,7 @@ static void cyttsp4_free_si_ptrs(struct
>  	kfree(si->btn_rec_data);
>  }
>  
> -#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
> +#ifdef CONFIG_PM
>  static int cyttsp4_core_sleep(struct cyttsp4 *cd)
>  {
>  	int rc;
> 

-- 
Dmitry
