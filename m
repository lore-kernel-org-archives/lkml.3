Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3IPQRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:17:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48452 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3IPQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:17:51 -0400
Message-ID: <52372F2A.2050003@wwwdotorg.org>
Date: Mon, 16 Sep 2013 10:17:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
References: <1379300274.4098.77.camel@pasglop>
In-Reply-To: <1379300274.4098.77.camel@pasglop>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 08:57 PM, Benjamin Herrenschmidt wrote:
> [resent to the right list this time around]
> 
> Hi folks !
> 
> So I don't have the bandwidth to follow closely what's going on, but I
> just today noticed the crackpot that went into 3.11 as part of commit:
> 
> 9d8eab7af79cb4ce2de5de39f82c455b1f796963
> drivers: of: add initialization code for dma reserved memory
> 
> Fist of all, do NOT add (or change) a binding as part of a patch
> implementing code, it's gross.

Personally, I would argue the opposite; it's much easier to see what's
going on when it's all together in one patch. Ensuring ABI stability can
only be achieved through code review, i.e. splitting into separate
DT/code patches won't achieve that, so that argument doesn't affect this.

...
> Additionally, it has the following issues:
> 
>  - It describes the "memory" node as /memory, which is WRONG
> 
> It should be "/memory@unit-address, this is important because the Linux
> kernel of_find_device_by_path() isn't smart enough to do partial
> searches (unlike the real OFW one) and thus to ignore the unit address
> for search purposes, and you *need* the unit address if you have
> multiple memory nodes (which you typically do on NUMA machines).

Perhaps /memory should have had a unit-address, but it never has had on
ARM; see arch/arm/boot/dts/skeleton.dtsi which says:

        memory { device_type = "memory"; reg = <0 0>; };

... and the fact that reg in /memory can have multiple entries seems to
support the expectation we only have a single node here. I'm not sure
how we could possibly change this now it's become so entrenched?
