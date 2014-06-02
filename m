Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaFBQ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:29:29 -0400
Received: from mout.perfora.net ([74.208.4.195]:53868 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbaFBQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:29:27 -0400
Message-ID: <538CA635.4050502@ziswiler.com>
Date: Mon, 02 Jun 2014 18:28:37 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com> <538CA24B.1010602@wwwdotorg.org>
In-Reply-To: <538CA24B.1010602@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:RNNSCaJeCh7dBLxPAB254HvPYdiAxVtjrYoftvUsDQX
 OtPPOL58G8XlCzH6QRj8CRloGrPDQE+4QILcUD0KFR1fdy5qZe
 PjGWSpy/JAB/RiHiIbhQIh5Bwy7lJlr39jXi0oaTSeLT84wW7G
 WnrrdXPU9w66KCaxqgmwS4MJC6x9Ie38ghEPQcdQGuTx25Zaof
 6M6vVT7vx/ofXg9XCk1SU5TncUUI7b3DmvKxlTmDLW9+azOeal
 fjh5X7aLXrw5DtDbPla8Km/gCr8mEffpMnlm3MaaYapF1cwxjc
 FxkwYVCQllNL+X7g15MrQ4o/I9C1Ny2vGN5SvGzcyxHdxNhDh6
 G7muq1R+Fzl19/+YDvOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 06:11 PM, Stephen Warren wrote:
>> BTW: How about MTD_SPI_NOR,
>
> That might only exist in linux-next.
>
>> PROC_DEVICETREE and CRYPTO_DEV_TEGRA_AES
>> which I haven't found any mentioning anywhere?
>
> The TEGRA_AES driver has been removed, so the option should be removed
> from defconfig too. I don't know what happened to PROC_DEVICTREE - it
> doesn't seem to exist any more. Was it replaced by something else or
> deleted? Feel free to send patches for those.

OK, will do.

>> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
>
>> +CONFIG_SPI_SPIDEV=y
>
> Is this useful with DT? I thought that unlike I2C_CHARDEV, spidev needed
> dummy devices to exist in DT for spidev to work? If so, there's not much
> point adding the option to defconfig, since people can add it when they
> put the dummy devices into DT.

Yes, the Apalis T30 DT I sent actually contains two of them which we 
call generic Apalis SPI1 and SPI2 out-of-the-box configured for exactly 
that. Without the config enabled though it probably does not make much 
sense to include it in the DT so I would consider removing it again.
