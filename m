Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaILQfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:35:51 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58134 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaILQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
	<7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
Date: Fri, 12 Sep 2014 13:35:48 -0300
Message-ID: <CAOMZO5A4FLbA_+u4oMTqgAY69DaF93V=oLiy+op=tEHbagF1pg@mail.gmail.com>
Subject: Re: [PATCH V1 1/3] ARM: clk-imx6sl: refine clock tree for SSI
From: Fabio Estevam <festevam@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 6:13 AM, Shengjiu Wang
<shengjiu.wang@freescale.com> wrote:
> Each SSI has "ssi", "ssi_ipg" clocks, and they share same gate bits.
>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>

This patch breaks audio playback on imx6q-sabresd:

root@freescale /$ aplay /home/clarinet.wav
Playing WAVE '/home/clarinet.wav' : Signed 16 bit Little Endian, Rate 44100 Hz,
Mono
underrun!!! (at least -1585992.581 ms long)
underrun!!! (at least -1585992.585 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)
underrun!!! (at least -1585992.586 ms long)

If I revert this commit, then I am able to play it well again.
