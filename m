Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3ANQez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:34:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54812 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3ANQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:34:52 -0500
Message-ID: <50F433A9.8020105@wwwdotorg.org>
Date: Mon, 14 Jan 2013 09:34:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org
Subject: Re: [PATCH] timer: vt8500: Move timer code to drivers/clocksource
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz> <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2013 10:09 PM, Tony Prisk wrote:
> This patch moves arch-vt8500/timer.c into drivers/clocksource and
> updates the necessary Kconfig/Makefile options.

> diff --git a/include/linux/vt8500_timer.h b/include/linux/vt8500_timer.h

> +#ifndef __VT8500_TIMER_H
> +#define __VT8500_TIMER_H
> +
> +#include <asm/mach/time.h>
> +
> +void vt8500_timer_init(void);
> +
> +#endif

Is VT8500 DT-only? If so, it'd be nice not to add this header, but
instead use CLOCKSOURCE_OF_DECLARE() inside the driver C file.
