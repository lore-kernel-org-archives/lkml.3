Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaF3Qzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:55:42 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:65065 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaF3Qzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:55:40 -0400
Message-ID: <53B19687.5050400@cogentembedded.com>
Date: Mon, 30 Jun 2014 20:55:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: tj@kernel.org, kishon@ti.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/7] phy: add a driver for the Berlin SATA PHY
References: <1403530783-17180-1-git-send-email-antoine.tenart@free-electrons.com> <1403530783-17180-2-git-send-email-antoine.tenart@free-electrons.com> <53AB1CFD.4040500@cogentembedded.com> <20140630095940.GB10058@kwain> <53B176F1.5060308@gmail.com> <20140630154409.GB29613@kwain>
In-Reply-To: <20140630154409.GB29613@kwain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/30/2014 07:44 PM, Antoine Ténart wrote:

>>>>> +	/* set the controller speed */
>>>>> +	writel(0x31, ctrl_reg + PORT_SCR_CTL);

>>>>     Value undocumented? Or is this the SATA SControl register by chance?

>>> Some magic is still there...

>> I guess Sergei was referring to AHCI spec here.

    Actually, even to the SATA specs. :-)

>> PORT_SCR bits are documented in AHCI spec as:

>> 7:4 = 0x3 Limit speed negotiation to a rate not greater than Gen3
>>            communication rate.

>> 3:0 = 0x1 Perform interface communication sequence [...]. This is
>>            functionally equivalent to a hard reset [...].

>> So, the question is: Should we really need to reset controller in the
>> PHY driver or is it already done in AHCI common code? At least we
>> should change the comment to something like
>> /* set Gen3 controller speed and perform hard reset */

> I just checked, the AHCI common code has a function to do the reset:
> ahci_reset_controller(). As of the max speed negociation rate, I did not
> see it in the common AHCI functions.

    You've looked in a wrong place -- since SControl is a standard *SATA* 
register, it gets read/written by the libata core. The low-level driver only 
provides scr_{read|write}() methods.

> The eSATA port on the Berlin2Q works without this line, but it may be a
> good idea to keep the max speed negociation rate.

    It's usually libata's task to negotiate the SATA speed.

> Anyway, we can remove the reset part. Nice catch!

    Thanks.

> Antoine

WBR, Sergei

