Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbaAHTAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:00:43 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:52697 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbaAHTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:00:38 -0500
Message-ID: <52CDA032.3010804@overkiz.com>
Date: Wed, 08 Jan 2014 20:00:02 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com> <20140108183418.GA12358@obsidianresearch.com>
In-Reply-To: <20140108183418.GA12358@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11549762721196701930
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Le 08/01/2014 19:34, Jason Gunthorpe a écrit :
> On Wed, Jan 08, 2014 at 03:21:58PM +0100, Boris BREZILLON wrote:
>
>> +int of_get_nand_timings(struct device_node *np, struct nand_timings *timings)
>> +{
>> +	memset(timings, 0, sizeof(*timings));
>> +	of_property_read_u32(np, "tCLS-min", &timings->tCLS_min);
>> +	of_property_read_u32(np, "tCLH-min", &timings->tCLH_min);
>> +	of_property_read_u32(np, "tCS-min", &timings->tCS_min);
> [..]
>
> A while ago when discussing another controller it was pointed out
> these values are all auto-probable directly from the NAND via a ONFI
> defined GET FEATURE @0x01 query, and adding these timings to the DT
> was NAK'd..
>
> Basically you set the interface to the slowest ONFI timing mode, do
> the GET FEATURE to the NAND chip and then increase the interface speed
> to the highest mutually supported ONFI mode.

> Is there some reason you need to encode this in the DT?

What if the NAND does not support the ONFI interface (and this is
exactly the case for the NAND available on the cubietruck board:
H27UCG8T2ATR).

But I'm glag to hear about this ONFI feature :).
I'll add a function to retrieve these timings if the NAND support
the ONFI interface.

Best Regards,

Boris
>
> Jason

