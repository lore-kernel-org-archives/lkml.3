Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422671Ab3BGVoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:44:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3BGVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:44:03 -0500
Date: Thu, 7 Feb 2013 13:44:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v2] rtc: max8997: Add driver for max8997 rtc.
Message-Id: <20130207134401.b4d90982.akpm@linux-foundation.org>
In-Reply-To: <1360234887-12360-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1360234887-12360-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013 20:01:27 +0900
Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:

> This patch adds rtc driver for Maxim 8997 multifunction chip.
> Max8997 has rtc module in it. and it can be used for timekeeping
> clock and system alarm. It provide various operational mode those are
> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
> (Watchdog Timeout and Software Reset).
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
> v2
>  - Add module parameter to enable/disable WTSR, SMPL fuction.
>  - Add unregister_rtc_device() for accidental exit in probing.
>
> ...
>
> +/* Module parameter for WTSR function control */
> +static int wtsr_en = 1;
> +module_param(wtsr_en, int, 0444);
> +MODULE_PARM_DESC(wtsr_en, "Wachdog Timeout & Sofware Reset (default=on)");
> +/* Module parameter for SMPL function control */
> +static int smpl_en = 1;
> +module_param(smpl_en, int, 0444);
> +MODULE_PARM_DESC(smpl_en, "Sudden Momentary Power Loss (default=on)");

"default=on" is interesting.  For what reasons would a user ever want
to set this "off"?  Can we just remove the options and leave these
things enabled all the time for everyone?

