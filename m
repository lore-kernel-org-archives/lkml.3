Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaJ1QLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:11:38 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54373 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaJ1QLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:11:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH v7 4/7] ARM: dts: Enable Broadcom Cygnus SoC
Date: Tue, 28 Oct 2014 17:10:24 +0100
Message-ID: <12464460.6zhqY1bzdG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414011474-11821-5-git-send-email-sbranden@broadcom.com>
References: <1414011474-11821-5-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JjH4Y/4N0b4TO2bdNCkw+CE0THWAeS34NE4ZvHxRI21
 t46FWdr3iGdWIw2WS6UwJtpxFKoAm39STLygtvKA3riVUwBT80
 /JaWYQN50fgEWFCu8CYW2Yy6udG7fWHj5VHnWqgAWXB/RGjxim
 xvr5xLp4+vphIr7NT8C0gWJu9vpdSKl1xWqGa4pL6UWB1fx8A6
 25nZmR9gvDhv2A00SuYEHYjKXvQn7ICY1NAK0Kpjp0A4zosg/Y
 uQVbxIjhIJeswM4/17WLq7UaWhxnUeX7OeH66sPFUp/u+b1HzH
 lmKig7znt93TCH4tEjXS4tt0Qt1x+uCBSRHgDnyf4D/9NdKF/U
 MdSvIQReX+n4FBccfta4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2014 13:57:51 Scott Branden wrote:
> +
> +       aliases {
> +               serial0 = &uart3;
> +               serial1 = &uart0;
> +       };
> +
> +       chosen {
> +               bootargs = "console=ttyS0,115200 earlyprintk debug";
> +       };
> 

Please move the 'aliases' and 'chosen' node into the .dts files, these
are board specific, not SoC specific.

For chosen, please remove earlyprintk and debug, which don't normally
make sense unless you are debugging, and which will break in a multiplatform
kernel.

Please also add an "stdout-path = &uart3" property in chosen so that
earlycon can work. Note that earlycon is currently broken on arm32,
but we'll get there.

	Arnd
