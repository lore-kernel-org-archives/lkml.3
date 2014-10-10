Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaJJU7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:59:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaJJU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:59:23 -0400
Date: Fri, 10 Oct 2014 22:59:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - disable active multiplexing by default
In-Reply-To: <20141010205131.GA3271@dtor-ws>
Message-ID: <alpine.LNX.2.00.1410102252480.31343@pobox.suse.cz>
References: <20141010205131.GA3271@dtor-ws>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, Dmitry Torokhov wrote:

> Active multiplexing is a nice feature as it allows several pointing devices
> (such as touchpad and external mouse) use their native protocols at the
> same time. Unfortunately many manufacturers do not implement the feature
> properly even though they advertise it. The problematic implementations are
> never fixed, since Windows by default does not use this mode, and move from
> one BIOS/model of laptop to another. When active multiplexing is broken
> turning it on usually results in touchpad, keyboard, or both unresponsive.
> 
> With PS/2 usage on decline (most of PS/2 devices in use nowadays are
> internal laptop touchpads), I expect number of users who have laptops with
> working MUX implementation, docking stations with external PS/2 ports, and
> who are still using external PS/2 mice, to be rather small. Let's flip the
> default to be OFF and allow activating it through i8042.nomux=0 kernel
> option.  We'll also keep DMI table where we can record known good models.

Being responsible for introducing a non-trivial portion of 
i8042_dmi_nomux_table[] entries:

	Acked-by: Jiri Kosina <jkosina@suse.cz>

If nothing else, it'd make my life easier :)

[ ... snip ... ]
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index f5a98af..9a97c2b 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -39,7 +39,7 @@ static bool i8042_noaux;
>  module_param_named(noaux, i8042_noaux, bool, 0);
>  MODULE_PARM_DESC(noaux, "Do not probe or use AUX (mouse) port.");
>  
> -static bool i8042_nomux;
> +static bool i8042_nomux = true;

Hmmm ... perhaps if we want to be really friendly, we should warn (and I 
definitely don't mean WARN(), but rather pr_info() or something) if we 
encounter that the cmdline contains 'i8042.nomux=1'.

Thanks,

-- 
Jiri Kosina
SUSE Labs
