Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaGaQy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:54:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37215 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751350AbaGaQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:54:56 -0400
Date: Thu, 31 Jul 2014 18:48:37 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org,
        =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>,
        Nicolas FERRE <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, voice.shen@atmel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
Message-ID: <20140731164836.GI3214@piout.net>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz>
 <20140728122103.GR9532@piout.net>
 <53D64ADA.1000102@aksignal.cz>
 <20140728223859.GA3214@piout.net>
 <20140729100017.31f0b1be@bbrezillon>
 <20140731155906.GH3214@piout.net>
 <C5B462AE-B1D2-4067-91EB-44FDF49D28FA@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C5B462AE-B1D2-4067-91EB-44FDF49D28FA@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 at 00:10:05 +0800, Jean-Christophe PLAGNIOL-VILLARD wrote :
> >>> While this solves the particular issue Jiří is seeing, this will not
> >>> solve the case where PA14 (CS0) is not used by the spi driver at all. It
> >>> will remained muxed as CS0 and toggle when the spi master needs to
> >>> access CS0 until another driver muxes it to something else. I still
> >>> believe we should explicitly ask pinctrl to mux them as gpios.
> 
> This is not the job of the kernel but to the bootloader
> no the pinctrl binding is not here and will never be here the configure a pin as a GPIO or

This is exactly what AT91_PERIPH_GPIO does though. Anyway, not request
the pinmuxing in the driver is not a good idea, then nothing prevents
another driver to request them to do something completely different.

> to a specific state. This the job of the driver or the bootloader
> 

I agree that it must not allow to set the state, we are talking about
muxing.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
