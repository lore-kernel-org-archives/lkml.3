Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3FEUTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:19:31 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:54926 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756628Ab3FEUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:19:28 -0400
Message-ID: <51AF9D52.2030609@calxeda.com>
Date: Wed, 05 Jun 2013 15:19:30 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/2 v2] sata highbank: add bit-banged SGPIO driver support
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com> <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com> <20130603203727.GB29989@mtj.dyndns.org> <51AE0335.902@calxeda.com> <20130604203251.GF14916@htj.dyndns.org>
In-Reply-To: <20130604203251.GF14916@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 03:32 PM, Tejun Heo wrote:
> Hello, Mark.
> 
> On Tue, Jun 04, 2013 at 10:09:41AM -0500, Mark Langsdorf wrote:
>>> And tell ahci core sizeof(ecx_host_priv) some way, but really, just
>>> having a plain pointer should be enough, I think.
>>
>> I think I want to do the opposite. For 90% of the AHCI EM functions,
>> I want ecx_host_priv to be an ahci_host_priv so that I can use those
>> functions without having to keep a local copy of them.
>>
>> Would something like this:
>> struct ahci_host_priv {
>> 	/* standard AHCI existing stuff */
>> 	void *private_data;
>> };
>>
>> I shied away from that because a private data structure having a private
>> data structure doesn't seem right.
> 
> Aren't we talking about the same thing?  I'm perfectly fine with
> adding a pointer to ahci_host_priv.  Maybe you can name it slightly
> differently - say, *impl_data, *platform_data, whatever.

I guess we are talking about the same thing. I'll do that.

>>>> +static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
>>>> +					ssize_t size)
>>>> +{
>>> ...
>>>> +	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED)
>>>> +		return size;
>>>
>>> Is this really correct?  You first negate and convert it to bool and
>>> then bit-wise and it with a mask?  How is supposed to work?
>>
>> Am I confused about the order of operations? It's meant to be "continue
>> if hpriv->em_msg_type doesn't have EM_MSG_TYPE_LED set".
> 
> Shouldn't that be
> 
> 	if (!(hpriv->em_msg_type & EM_MSG_TYPE_LED))
> 
> ! has higher priority than &.  You're converting em_msg_type to 1 or 0
>   and then and'ing EM_MSG_TYPE_LED to it.

I'll fix it then.

--Mark Langsdorf
Calxeda, Inc.
