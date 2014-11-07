Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKGQPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:15:47 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44477 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKGQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:15:45 -0500
Message-ID: <545CF02A.9060500@collabora.co.uk>
Date: Fri, 07 Nov 2014 17:15:38 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 5/5] regulator: of: Add support for parsing initial
 and suspend modes
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-6-git-send-email-javier.martinez@collabora.co.uk> <20141107154743.GT8509@sirena.org.uk>
In-Reply-To: <20141107154743.GT8509@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 04:47 PM, Mark Brown wrote:
> On Fri, Nov 07, 2014 at 02:00:05PM +0100, Javier Martinez Canillas wrote:
> 
>> +	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
>> +		if (desc && desc->map_modes)
>> +			constraints->initial_mode = desc->map_modes(pval);
>> +		else
>> +			pr_warn("%s: failed to parse regulator-initial-mode\n",
>> +				np->name);
>> +	}
> 
> This is ignoring any error return from map_modes(), it's possible the DT
> might have an invalid value.  The error message could also use some
> improvement, it's more that the kernel doesn't understand how to parse
> it even if it is valid.
> 

Right, as I mentioned to Krzysztof in a previous email, I'll remove the
warning message and add an error message instead if the map mode callback
function fails and also show the error code as you suggest.

Best regards,
Javier
