Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3G3VZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:25:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60886 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3G3VZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:25:49 -0400
Message-ID: <51F82F58.8090705@wwwdotorg.org>
Date: Tue, 30 Jul 2013 15:25:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: Add DVFS mux setting
References: <1374871308-490-1-git-send-email-achew@nvidia.com> <51F2E74E.2060107@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com> <51F2EC66.2080200@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274113@HQMAIL03.nvidia.com> <51F2F22B.500@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274137@HQMAIL03.nvidia.com> <51F398F8.5070602@nvidia.com> <51F81FF5.4020600@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274697@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763862A1274697@HQMAIL03.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 02:53 PM, Andrew Chew wrote:
>> On 07/27/2013 03:55 AM, Laxman Dewangan wrote:
>>> On Saturday 27 July 2013 03:42 AM, Andrew Chew wrote:
>>>> I wrote:
>>>>> Andrew wrote:
>>>>>> [adding a third pinmux configuration property to Palmas's DT]
>>>>>
>>>>> How does this interact with the pinctrl driver that Laxman just sent
>>>>> for Palmas?
>>>>>
>>>>> https://lkml.org/lkml/2013/7/26/141
>>>>> [PATCH 0/2] pinctrl: palmas: add pincontrol driver
>> ..
>>>> Abandoning this patch.
>> ...
>>> once we will have the pincontrol driver then mux pads are become
>> redundant.
>>
>> OK. The driver should probably operate like this then:
>>
>> * During probe(), parse the ti,mux-pad* parameters, if present, and apply
>> them. This is needed to maintain compatibility with old DTs that may contain
>> these properties.
>>
>> * At the end of probe(), register the pinctrl driver. If standard pinctrl
>> properties are present in DT, these will then be applied. These may override
>> the values set by any ti,mux-pad* properties if they were present.
>>
>> Also, we should remove, or mark deprecated, the ti,mux-pad* properties in
>> the binding document when adding pinctrl support.
> 
> Sounds reasonable to me.  The fate of my patch hasn't really been discussed, though.
> Can we apply it, to make the ti,mux-pad* stuff complete?

Oh, I thought you said you were dropping it. I don't see a need to apply
it if the correct approach is Laxman's pinctrl driver.
