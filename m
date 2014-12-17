Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLQVy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:54:56 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:60555 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaLQVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:54:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, kernel@stlinux.com, rtc-linux@googlegroups.com,
        devicetree@vger.kernel.org, wim@iguana.be, linux@roeck-us.net,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 5/8] watchdog: bindings: Provide ST bindings for ST's LPC Watchdog device
Date: Wed, 17 Dec 2014 22:54:12 +0100
Message-ID: <5479005.CEJLtxOOIa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418834727-1602-6-git-send-email-lee.jones@linaro.org>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org> <1418834727-1602-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:4fKXlDRY4gkfVp0wDDupvZWL6wp/p0TwGEzPqF+o/vYTNscVtUL
 BPH/6kfkAxqJfbg2l0iRYPPzV0jRhenq0hAlmbFWYZhkeF5eOMe6mtRCUAQ3KYvA3T4wxY6
 vmun2vknOp5Q34Li7jCBlufP1d63CPoMBCkOrHdmqDyBfF/Xqr6FC/sq+CzMkV2nJlUxIPf
 hwxWvMTDjyt4eoocS43MA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 16:45:24 Lee Jones wrote:
> +- compatible   : Must be one of: "st,stih407-lpc" "st,stih416-lpc"
> +                                 "st,stih415-lpc" "st,stid127-lpc"
> +- reg          : LPC registers base address + size
> +- interrupts    : LPC interrupt line number and associated flags
> +- clocks       : Clock used by LPC device (See: ../clock/clock-bindings.txt)
> +- st,lpc-mode  : The LPC can run either one of two modes ST_LPC_MODE_RTC [0] or
> +                 ST_LPC_MODE_WDT [1].  One (and only one) mode must be
> +                 selected.
> 

I'm glad you got it to work with two drivers for the same device.

With this binding, I'm still a bit unhappy about the st,lpc-mode property,
in particular since you rely on a shared include file for something that
can only be set in one way or another and always has to be present.

Why not just use a boolean property that enforces one mode when present
and another mode when absent?

	Arnd
