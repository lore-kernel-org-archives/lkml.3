Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaAHMDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:03:31 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:44392 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaAHMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
	<1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
Date: Wed, 8 Jan 2014 10:03:26 -0200
Message-ID: <CAOMZO5BXssO2BaV01Hn6hWaEP+k8_Bp7NPUKDbJ8-yuG8Eo41Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "ARM: dts: imx: use dual-fifo sdma script for ssi"
From: Fabio Estevam <festevam@gmail.com>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 6:45 AM, Nicolin Chen <Guangyu.Chen@freescale.com> wrote:
> This reverts commit b1d27c79c8377df1880447375deffa3bb82c7bd3.
>
> Previously we switched the SSI scriprt to dual-fifo mode to reduce playback
> underrun issue, which is only included by SDMA firmware version 2. However,
> there are quite a lot people still using version 1 or default firmware in
> the ROM code of SoC while these two kinds of firmwares do not support the
> dual-fifo script and the audio function on their platform would be broken.
>
> Thus this patch provisionally reverts the dual-fifo script to the original
> single fifo script to meet all kinds of users' requirements, including the
> version 1/2 or inner ROM firmware.
>
> Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>

Thanks, Nicolin.

This fixes audio playback without additional SDMA firmware:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
