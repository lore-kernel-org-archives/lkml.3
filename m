Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3BMTy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:54:56 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33190 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3BMTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:54:55 -0500
Message-ID: <511BEF8D.7060506@gmail.com>
Date: Wed, 13 Feb 2013 13:54:53 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Murray <andrew.murray@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de> <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de> <511949C7.7070604@gmail.com> <20130212064523.GA28850@avionic-0098.mockup.avionic-design.de> <511BA1E0.9000404@gmail.com> <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 08:25 AM, Thierry Reding wrote:
> On Wed, Feb 13, 2013 at 08:23:28AM -0600, Rob Herring wrote:
>> On 02/12/2013 12:45 AM, Thierry Reding wrote:
>>> On Mon, Feb 11, 2013 at 01:43:03PM -0600, Rob Herring wrote:
>>>> On 02/11/2013 02:22 AM, Thierry Reding wrote:
>>>>> From: Andrew Murray <andrew.murray@arm.com>
>>
>>>>> @@ -13,6 +13,7 @@
>>>>>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
>>>>>  
>>>>>  static struct of_bus *of_match_bus(struct device_node *np);
>>>>> +static struct of_bus *of_find_bus(const char *name);
>>>>
>>>> Can you move this function up to avoid the forward declaration.
>>>
>>> It needs to be defined after the of_busses structure, which is defined
>>> below the CONFIG_PCI block where of_pci_process_ranges() is defined. I'd
>>> have to move that one as well and add another #ifdef CONFIG_PCI section.
>>> If you prefer that I can do that.
>>
>> Okay, it's fine as is.
>>
>>>>> +static struct of_bus *of_find_bus(const char *name)
>>>>> +{
>>>>> +	unsigned int i;
>>>>> +
>>>>> +	for (i = 0; i < ARRAY_SIZE(of_busses); i++)
>>>>> +		if (strcmp(name, of_busses[i].name) == 0)
>>>>                                               ^
>>>> space needed.
>>>
>>> I don't understand. Do you want the space to go between '.' and "name"?
>>
>> Must have been some dirt on my screen... Never mind.
>>
>> I'll apply these for 3.9.
> 
> Great, thanks!

Grant vetoed merging. We need to see the other architectures using these
functions rather than add yet another copy.

Rob

