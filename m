Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaJIOmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:42:01 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62016 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaJIOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:41:53 -0400
Message-ID: <54369EAC.5040301@gmail.com>
Date: Thu, 09 Oct 2014 16:41:48 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFT 0/8] Marvell PXA168 libphy handling and Berlin Ethernet
References: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com> <20141009163315.2a9e1806@free-electrons.com>
In-Reply-To: <20141009163315.2a9e1806@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 04:33 PM, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
>
> On Thu,  9 Oct 2014 14:38:58 +0200, Sebastian Hesselbarth wrote:
>
>> This patch series deals with a removing a IP feature that can be found
>> on all currently supported Marvell Ethernet IP (pxa168_eth, mv643xx_eth,
>> mvneta). The MAC IP allows to automatically perform PHY auto-negotiation
>> without software interaction.
>>
>> However, this feature (a) fundamentally clashes with the way libphy works
>> and (b) is unable to deal with quirky PHYs that require special treatment.
>> In this series, pxa168_eth driver is rewritten to completely disable that
>> feature and properly deal with libphy provided PHYs. The other two drivers
>> are suspect to future patch sets, also removing the code related with it.
>
> Hum, in mvneta, we already disabled the automatic negotiation and use
> libphy. What makes you think the current mvneta driver is wrong in this
> respect?

I didn't check mvneta, but remember Ezequiel didn't clear all AN bits
in the barebox driver (which is based on Linux mvneta). Just mentioned
that I'll have a closer look at it.

But I agree, regarding libphy support mvneta is probably the best
already.

Sebastian

