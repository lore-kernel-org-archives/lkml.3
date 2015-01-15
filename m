Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbAONXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:23:12 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:53778 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAONXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:23:11 -0500
X-ME-Helo: beldin
X-ME-Date: Thu, 15 Jan 2015 14:23:08 +0100
X-ME-IP: 109.214.23.205
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] pxa_timer: fix session missmatch warning
References: <1421286860-23296-1-git-send-email-dbaryshkov@gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 15 Jan 2015 14:23:00 +0100
In-Reply-To: <1421286860-23296-1-git-send-email-dbaryshkov@gmail.com> (Dmitry
	Eremin-Solenikov's message of "Thu, 15 Jan 2015 04:54:20 +0300")
Message-ID: <87h9vsxjnv.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:

> Fix the following warning:
>
> WARNING: drivers/clocksource/built-in.o(.text.unlikely+0x70): Section mismatch in reference from the function pxa_timer_common_init() to the function .init.text:clocksource_mmio_init()
> The function pxa_timer_common_init() references
> the function __init clocksource_mmio_init().
> This is often because pxa_timer_common_init lacks a __init
> annotation or the annotation of clocksource_mmio_init is wrong.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

On a side note, I never get this warning in my builds, either on linux-next or
linus tree, probably because pxa_timer_common_init() is always inlined in my
builds.

Cheers.

--
Robert
