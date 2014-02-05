Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaBEXLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:11:47 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43337 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaBEXLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:11:44 -0500
Message-ID: <52F2C52B.60001@gmail.com>
Date: Thu, 06 Feb 2014 00:11:39 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 11:59 PM, Gregory CLEMENT wrote:
> Until now the clock providers were initialized in the order found in
> the device tree. This led to have the dependencies between the clocks
> not respected: children clocks could be initialized before their
> parent clocks.
>
> Instead of forcing each platform to manage its own initialization order,
> this patch adds this work inside the framework itself.
>
> Using the data of the device tree the of_clk_init function now delayed
> the initialization of a clock provider if its parent provider was not
> ready yet.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> [...]
> this patch could solve the issues we get on severals mvebu platform
> since 3.14-rc1. This is an alternate solution of the patch set sent by
> Sebastian. However as it modifies the clock framework itself, it is
> more sensible.
>
> I find this solution more elegant than changing the order of the
> initialization of the clock at the platform level. However as it
> should be tested on more platforms that only the mvebu ones, it would
> take some time, and I don't want to still have "broken" platform
> during more release candidate. So at the end this patch should be part
> of the 3.15 kernel.

Gregory,

I admit, your patch is more general and I am looking forward to revert
the reorder fix as soon as this is ready :)

BTW, what happened to the early device discussion? Couldn't this be
picked up here to allow -EPROBE_DEFER also for those early drivers?

Sebastian
