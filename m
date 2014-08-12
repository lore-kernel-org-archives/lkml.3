Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaHLRVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:21:43 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38322 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaHLRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:21:41 -0400
Message-ID: <53EA4D1F.2030406@collabora.co.uk>
Date: Tue, 12 Aug 2014 19:21:35 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: dts: Create fragment for tps65090 PMU
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk> <1407861868-20097-2-git-send-email-javier.martinez@collabora.co.uk> <20140812165852.GT17528@sirena.org.uk>
In-Reply-To: <20140812165852.GT17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/12/2014 06:58 PM, Mark Brown wrote:
> On Tue, Aug 12, 2014 at 06:44:23PM +0200, Javier Martinez Canillas wrote:
>> The tps65090 is a Power Management Unit (PMU) used in several
>> boards so the same information is described on different DTS.
>> It is better to create a .dtsi fragment that can be included.
> 
> Why is it better to do this?
>

Is better IMHO because we have a single place where the tps65090 information can
be updated instead of duplicating the same definition on each DTS.

This appears to be the current trend to better manage shared DTS snippet across
different boards. Others examples are arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi
and arch/arm/boot/dts/twl6030.dtsi.

>> +	regulators {
>> +		tps65090_dcdc1: dcdc1 {
>> +		};
>> +
> 
> It appears to be largely content free, exactly the same effect should be
> achieved by removing the entire regulators node.
> 

Yes it's content free but later "[PATCH 6/6] ARM: dts: Add tps65090 FETs
constraints" [0] fills the FETs constraints [0]. This is a preparatory patch.

Also, having all the regulators allows DTS files to reference the node by the
label if they want to add other properties. I can squash this patch and 06/06 if
you think that is better but I thought that the split makes it easier to review.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/8/12/377
