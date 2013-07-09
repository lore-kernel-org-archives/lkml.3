Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3GIO1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:27:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44693 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3GIO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:27:01 -0400
Message-ID: <51DC1DB4.3050802@wwwdotorg.org>
Date: Tue, 09 Jul 2013 08:27:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Huang Shijie <b32955@freescale.com>, grant.likely@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: match the compatible in the order set by the dts
 file
References: <1373013818-11365-1-git-send-email-b32955@freescale.com> <20130709070541.GQ516@pengutronix.de>
In-Reply-To: <20130709070541.GQ516@pengutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 01:05 AM, Sascha Hauer wrote:
> On Fri, Jul 05, 2013 at 04:43:38PM +0800, Huang Shijie wrote:
>> If we set the uart compatible in the dts file like this:
>>    ------------------------------------------------------
>>     compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>>    ------------------------------------------------------
>>
>> and we set the uart compatible in the uart driver like this:
>>    ------------------------------------------------------
>> 	{ .compatible = "fsl,imx1-uart", ... },
>> 	{ .compatible = "fsl,imx21-uart", ... },
>> 	{ .compatible = "fsl,imx6q-uart", ... },
>> 	{ /* sentinel */ }
>>    ------------------------------------------------------
>>
>> the current code will match the "fsl,imx21-uart" in the end.
>>
>> Of course, this is not what we want. We want it to match the "fsl,imx6q-uart".
>>
>> This patch rewrites the match code, and make it to check the compatible
>> in the order set by the DTS file.
> 
> Why don't you set the matching order in the driver the way you want it
> to be, i.e.:
> 
> 	{ .compatible = "fsl,imx6q-uart", ... },
> 	{ .compatible = "fsl,imx21-uart", ... },
> 	{ .compatible = "fsl,imx1-uart", ... },

DT semantics are that earlier entries in the compatible property are
supposed to be matched first, irrespective of how the driver is constructed.

