Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaGQA4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:56:16 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:45590 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752819AbaGQA4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:56:14 -0400
Message-ID: <53C71F1F.8040607@daenzer.net>
Date: Thu, 17 Jul 2014 09:55:59 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, romieu@fr.zoreil.com
CC: hayeswang@realtek.com, nic_swsd@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
References: <1405406500-1208-1-git-send-email-michel@daenzer.net>	<0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>	<20140715215412.GA19363@electric-eye.fr.zoreil.com> <20140716.152517.952351917803362794.davem@davemloft.net>
In-Reply-To: <20140716.152517.952351917803362794.davem@davemloft.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2014 07:25, David Miller wrote:
> From: Francois Romieu <romieu@fr.zoreil.com>
> Date: Tue, 15 Jul 2014 23:54:12 +0200
> 
>> Hayes Wang <hayeswang@realtek.com> :
>>>  Michel D?nzer [mailto:michel@daenzer.net] 
>> [...]
>>>> Without this, the ethernet port on my ASUS A88X Pro mainboard stops
>>>> working sometimes, with messages like these in dmesg:
>>>>
>>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
>>>> domain=0x001e address=0x0000000000003000 flags=0x0050]
>>>
>>> I search the information about your issue. It seems to be
>>> relative to the IOMMU. I don't sure if your patch is the root
>>> cause or a workaround.
>>
>> Btw, a few extra identifiers in rtl_init_rxcfg may improve consistency:
>>
>>            missing             |          included
>> -------------------------------+-------------------------------
>> RTL_GIGA_MAC_VER_36 (8168f)    | RTL_GIGA_MAC_VER_35 (8168f)
>> RTL_GIGA_MAC_VER_38 (RTL8411)  | RTL_GIGA_MAC_VER_44 (RTL8411)
>> RTL_GIGA_MAC_VER_39 (RTL8106e) | RTL_GIGA_MAC_VER_43 (RTL8106e)
>> RTL_GIGA_MAC_VER_37 (RTL8402)  |
> 
> Michel please take Francois's feedback here into consideration and also
> provide a more detailed commit message so other people reading the commit
> can understand your reasoning for making this change, not just what the
> result might be for making it.

I'm afraid I can't do that. I don't really understand any of this stuff,
I just googled the IOMMU event message, found similar patches for other
chipsets, and adapted them for my mainboard until the problem stopped.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
