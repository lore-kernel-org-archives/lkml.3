Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab3EOOK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:10:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914Ab3EOOK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:10:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv3 2/6] arm: Add device trees for TI-Nspire
Date: Wed, 15 May 2013 16:10:22 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-3-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1368332581-94691-3-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151610.23145.arnd@arndb.de>
X-Provags-ID: V02:K0:6gtZgd3ZtGSJTzhgyYDq/CplJ8kgGxLAYuQlKPdPJhr
 vt5IoMlSsm/wWqh6ywi62dW2ydxGjAKKBw20CS7QihnWKzhrKC
 Awqq6lA8pn5hNaPTopffOJXd7lxcWLE42BrsaslWKvqyhiSz4H
 R81impc/qn8ON95VTaalEwZl+jSdsRtaFUWVKHirzU1FiBfqwS
 37qngzaqRoKEaQ3XR1bynRUIUGgaEeKoJlm26cZBh/1xHA+KUv
 /Ccnpc/RFpdfr2ZBtr3Id4dC+CQqMpPRAIfpxsHHa3Jx2aER1R
 umrHdmZhq7DH7Tx1u48aWS2Uk6xihVYKzPXGG3BswekGRDC0J7
 Tq+P7kCb17IzpDhfckhI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 May 2013, Daniel Tang wrote:
> +
> +                       timer0: timer@900C0000 {
> +                               reg = <0x900C0000 0x1000>;
> +
> +                               clocks = <&timer_clk>;
> +                               clock-names = "timer_clk";
> +                       };
> +
> +                       timer1: timer@900D0000 {
> +                               reg = <0x900D0000 0x1000>;
> +                               interrupts = <19>;
> +
> +                               clocks = <&timer_clk>;
> +                               clock-names = "timer_clk";
> +                       };


> +                               clocks = <&apb_pclk>;
> +                               clock-names = "apb_pclk";
> +                       };

Why do you provide "clock-names" here? Do those devices have multiple
clock inputs? It's normally easier to just use the default clock
input.

	Arnd
