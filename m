Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaKDKug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:50:36 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59592 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaKDKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:50:33 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-b1-5458af7624dc
Message-id: <1415098229.7941.12.camel@AMDC1943>
Subject: Re: [PATCH v4 11/14] regulator: max77802: Document binding for
 regulator operating modes
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Nov 2014 11:50:29 +0100
In-reply-to: <1415025649-8119-12-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-12-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7pl6yNCDF4sVbaY+vAJm8X1L89Z
	LeYfOcdqcfR3gcWav0oWvQuusllc3jWHzWLG+X1MFqeuf2azmP9gB7MDl8ff59dZPHbOusvu
	sWlVJ5vHlRNNrB5/Z+1n8ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6M2adeMBb8FarYsHgm
	ewPjUf4uRk4OCQETiRsLG5ggbDGJC/fWs3UxcnEICSxllDi54QoLhPOZUeLCqbvMIFW8AvoS
	syZ8AesQFkiWeLDsAzuIzSZgLLF5+RI2EFtEwE7ixuqHzCDNzALHmCRmrlrHApJgEVCV6Oy9
	ytjFyMHBKRAgcfOTFMSCKYwSJ96sA2tmFlCXmDRvETNIjYSAskRjvxvEXkGJH5PvsUCUyEts
	XvOWeQKjwCwkHbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhUfNnBuPiY
	1SFGAQ5GJR7eDPWIECHWxLLiytxDjBIczEoivKurgEK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	ve7e7t3y58LzO2d2hIVxJoWcLOtdeeVE14YZP8v+/vWc9Dxw+oa0FboXbfhm5YgYb50ftvH2
	uzU/N90125dYGGUkuCrlUuAjRa7vYt9ydibdtBM4OG3unHu3u6SqNsznb2bLup+r3ZPzdc+j
	a4/er3SyPsy0bqrLxl2fyh51RPguv77J1uvPq5lKLMUZiYZazEXFiQCbdXHQaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-03 at 15:40 +0100, Javier Martinez Canillas wrote:
> Some regulators from the max77802 PMIC support to be configured in one
> of two operating mode: Output ON (normal) and Output On Low Power Mode.
> Not all regulators support these two modes and for some of them, the
> mode can be changed while the system is running in normal operation
> while others only support their mode to be changed on system suspend.
> 
> Extend the max77802 PMIC bindin by documenting the possible operating
> modes values so the regulators modes can be correctly configured.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes in v4: None
> 
> Changes in v3:
>  - Use the standard suspend states bindings as suggested by Mark Brown.
> 
>  .../devicetree/bindings/regulator/max77802.txt     | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/max77802.txt b/Documentation/devicetree/bindings/regulator/max77802.txt
> index 5aeaffc..1a78ec2 100644
> --- a/Documentation/devicetree/bindings/regulator/max77802.txt
> +++ b/Documentation/devicetree/bindings/regulator/max77802.txt
> @@ -25,6 +25,27 @@ with their hardware counterparts as follow. The valid names are:
>  			example: LDO1, LDO2, LDO35.
>  	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 10.
>  			example: BUCK1, BUCK5, BUCK10.
> +
> +The max77802 regulator supports two different operating modes: Normal and Low
> +Power Mode. Some regulators support the modes to be changed at startup or by
> +the consumers during normal operation while others only support to change the
> +mode during system suspend. The standard regulator suspend states binding can
> +be used to configure the regulator operating mode.
> +
> +The regulators that support the standard "regulator-initial-mode" property,
> +changing their mode during normal operation are: LDOs 1, 3, 20 and 21.
> +
> +The possible values for "regulator-initial-mode" and "regulator-mode" are:
> +	1: Normal regulator voltage output mode.
> +	3: Low Power which reduces the quiescent current down to only 1uA
> +
> +The list of valid modes are defined in the dt-bindings/regulator/regulator.h
> +header and can be included by device tree source files.

The more he looked inside, the more regulator.h wasn't there.

Best regards,
Krzysztof



