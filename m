Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaJTSR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:17:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43137 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaJTSRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:17:47 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] i2c/at91: adopt pinctrl support
References: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
	<1413776535-10123-4-git-send-email-wenyou.yang@atmel.com>
Date: Mon, 20 Oct 2014 11:17:43 -0700
In-Reply-To: <1413776535-10123-4-git-send-email-wenyou.yang@atmel.com> (Wenyou
	Yang's message of "Mon, 20 Oct 2014 11:42:14 +0800")
Message-ID: <7h4muyfvw8.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenyou Yang <wenyou.yang@atmel.com> writes:

> Amend the i2c at91 pin controller to optionally take a pin control
> handle and set the state of the pins to:
>
> - "default" on boot, resume and before performing an transfer
> - "sleep" on suspend()
>
> This should make it possible to optimize energy usage for the pins
> both for the suspend/resume cycle
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

This patch is a good example of why you should just have the ->suspend
function call the same function as ->runtime_suspend.

If you do that, rather than having to add the pinctrl_pm* calls bo both
system PM and runtime PM functions, you could've just added them to the
runtime PM functions.

Kevin
