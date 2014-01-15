Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaAOPJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:09:41 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:55072 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbaAOPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:09:37 -0500
Message-ID: <52D6A48D.4080302@overkiz.com>
Date: Wed, 15 Jan 2014 16:09:01 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com> <20140108183418.GA12358@obsidianresearch.com> <52CDA032.3010804@overkiz.com> <20140108191339.GB12358@obsidianresearch.com> <52CE5F82.6070802@overkiz.com> <20140109173505.GB8899@obsidianresearch.com>
In-Reply-To: <20140109173505.GB8899@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11857414870855940330
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

On 09/01/2014 18:35, Jason Gunthorpe wrote:
> On Thu, Jan 09, 2014 at 09:36:18AM +0100, boris brezillon wrote:
>
>>> You might want to check if you can boil down the DT timings from the
>>> huge list to just an ONFI mode number..
>> Sure, but the sunxi driver needs at least 19 of them...
> So does mvebu's NAND driver..
>
> What I ment was you could have a
>
>    onfi,nand-timing-mode = 0
>
> in the DT. Each of the modes defines all ~19 parameters, higher modes
> are faster.
>
> Pick a mode value that fits all the parameters of the connected
> non-ONFI flash.
>
> This would be instead of defining each parameter
> individually.. Provide some helpers to convert from a onfi mode number
> to all the onfi defined timing parameters so that drivers can
> configure the HW..

Are you suggesting we should provide a function that converts these
modes into a nand_timings struct, or just use the timing modes and
let the NAND controller drivers configure its IP accordingly ?

I found the ONFI timing tables in this document:

www.*onfi*.org/~/media/*ONFI*/specs/*onfi*_3_1_spec.pdf‎ (chapter 4.16).

I suppose my nand_timings struct should use the names described
page 110-111 (at least if we decide to use nand_timings and not
nand_timing_modes), right ?

Best Regards,

Boris

>
> Jason

