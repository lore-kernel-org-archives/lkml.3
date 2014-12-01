Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaLAXfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:35:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaLAXfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:35:12 -0500
Message-ID: <547CFB2C.4090008@suse.de>
Date: Tue, 02 Dec 2014 00:35:08 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stuart Yoder <stuart.yoder@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com> <54773557.6020600@suse.de> <CY1PR0301MB0748FD38A1FD925F273EB33A877D0@CY1PR0301MB0748.namprd03.prod.outlook.com>
In-Reply-To: <CY1PR0301MB0748FD38A1FD925F273EB33A877D0@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.12.14 23:28, Stuart Yoder wrote:
> 
> 
>> -----Original Message-----
>> From: Alexander Graf [mailto:agraf@suse.de]
>> Sent: Thursday, November 27, 2014 8:30 AM
>> To: Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
>> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; Hamciuc Bogdan-BHAMCIU1; Marginean
>> Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-B43082
>> Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex APIs
>>
>>
>>
>> On 13.11.14 18:54, J. German Rivera wrote:
>>> APIs to access the Management Complex (MC) hardware
>>> module of Freescale LS2 SoCs. This patch includes
>>> APIs to check the MC firmware version and to manipulate
>>> DPRC objects in the MC.
>>>
>>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>>
>> [...]
>>
>>> +/*
>>> + * Object descriptor, returned from dprc_get_obj()
>>> + */
>>> +struct dprc_obj_desc {
>>> +	/* Type of object: NULL terminated string */
>>> +	char type[16];
>>
>> I don't see where it actually gets NULL terminated - all 16 bytes come
>> directly from the device.
>>
>> While it's probably ok to trust it, I think we'd still be safer off if
>> we just make this a char[17] array to always have our NULL terminating
>> string. That way we're guaranteed we'll never run over our memory
>> boundaries.
> 
> The device is supposed to guarantee that the string is null 
> terminated...so there will never be valid chars in the 16th
> character.  So, what about just forcing type[15] = '\0'?
> 
> I think that would be better than making it a char[17].

Sure, that works too.


Alex
