Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKZDMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:12:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37755 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZDMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:12:06 -0500
Message-ID: <547544FE.5020706@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2014 21:11:58 -0600
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 07/14] of/reconfig: Always use the same structure for
 notifiers
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org> <1416868422-22103-8-git-send-email-grant.likely@linaro.org> <1416956874.5089.13.camel@kernel.crashing.org>
In-Reply-To: <1416956874.5089.13.camel@kernel.crashing.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112603-0005-0000-0000-000006A2814C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 05:07 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-11-24 at 22:33 +0000, Grant Likely wrote:
>> The OF_RECONFIG notifier callback uses a different structure depending
>> on whether it is a node change or a property change. This is silly, and
>> not very safe. Rework the code to use the same data structure regardless
>> of the type of notifier.
> 
> I fell pretty good about this one except...
> 
>> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
>> index b9d1dfdbe5bb..9fe6002c1d5a 100644
>> --- a/arch/powerpc/mm/numa.c
>> +++ b/arch/powerpc/mm/numa.c
>> @@ -1711,12 +1711,11 @@ static void stage_topology_update(int core_id)
>>  static int dt_update_callback(struct notifier_block *nb,
>>  				unsigned long action, void *data)
>>  {
>> -	struct of_prop_reconfig *update;
>> +	struct of_reconfig_data *update = data;
>>  	int rc = NOTIFY_DONE;
>>  
>>  	switch (action) {
>>  	case OF_RECONFIG_UPDATE_PROPERTY:
>> -		update = (struct of_prop_reconfig *)data;
> 
> Should we assert/bug on !update->dn / update->prop ?
> 
> (Same for the rest of the patch)
> 
> Or do you reckon it's pointless ?
> 

I'm not sure it's worth it, if those are NULL pointers the drivers/of
code would have tried to use them before invoking the notifier chain.
We won't make it this far if they're NULL.

Otherwise the patch looks good to me,

Reviewed-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

-Nathan

