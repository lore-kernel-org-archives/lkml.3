Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3FFMOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:14:08 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:50095 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932700Ab3FFMOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:14:05 -0400
Message-ID: <51B07D10.2060609@calxeda.com>
Date: Thu, 06 Jun 2013 07:14:08 -0500
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
Subject: Re: [PATCH 2/2] sata highbank: add bit-banged SGPIO driver support
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com> <1370471508-30806-1-git-send-email-mark.langsdorf@calxeda.com> <20130605231517.GP10693@mtj.dyndns.org>
In-Reply-To: <20130605231517.GP10693@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

,On 06/05/2013 06:15 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 05, 2013 at 05:31:48PM -0500, Mark Langsdorf wrote:
>> +static void ecx_parse_sgpio(struct ecx_plat_data *pdata, u32 port, u32 state)
>> +{
>> +	if (state & ECX_ACTIVITY_BITS)
>> +		pdata->sgpio_pattern |= sgpio_bit_shift(pdata, port,
>> +						ECX_ACTIVITY_SHIFT);
>> +	else
>> +		pdata->sgpio_pattern &= sgpio_bit_shift(pdata, port,
>> +						ECX_ACTIVITY_SHIFT);
> 
> Shouldn't it be "&= ~" instead of "&="?  You're trying to turn the bit
> off, right?

Oops. Thanks!

--Mark Langsdorf
Calxeda, Inc.

