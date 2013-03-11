Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3CKUsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:48:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32897 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKUsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:48:22 -0400
Message-ID: <513E4312.5060804@wwwdotorg.org>
Date: Mon, 11 Mar 2013 14:48:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Regulator API ignored return values
References: <201303112043.53334.arnd@arndb.de>
In-Reply-To: <201303112043.53334.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 02:43 PM, Arnd Bergmann wrote:
> Hi all,
> 
> Mark Brown has added a patch to Linux-next that warns about certain regulator
> API functions being called without checking the results, which seems to have
> uncovered a number of bugs.
> 
> I've added a few people to Cc that might be interested in the reports and
> in fixing these bugs. Below you can find a list of all instances I found
> building the ARM defconfigs.

> ==> build/tegra_defconfig/faillog <==
> /git/arm-soc/arch/arm/mach-tegra/board-harmony-pcie.c: In function 'harmony_pcie_init':
> /git/arm-soc/arch/arm/mach-tegra/board-harmony-pcie.c:65:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

This one should be fixed by 84b808d "ARM: tegra: fix ignored return
value of regulator_enable" the next time next is rebuilt.
