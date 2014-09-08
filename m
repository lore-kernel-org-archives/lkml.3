Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaIHOaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:30:06 -0400
Received: from [65.55.169.124] ([65.55.169.124]:30895 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbaIHOaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:30:04 -0400
X-Greylist: delayed 859 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 10:30:04 EDT
Message-ID: <540DB995.7040406@freescale.com>
Date: Mon, 8 Sep 2014 17:13:41 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
Subject: Re: [PATCH] of: make sure of_alias is initialized before accessing
 it
References: <53FDE6A3.3080303@freescale.com> <20140908132956.646FEC40AE5@trevor.secretlab.ca>
In-Reply-To: <20140908132956.646FEC40AE5@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: DB4PR05CA0037.eurprd05.prod.outlook.com (25.160.40.47) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03283976A6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019017)(6009001)(6049001)(24454002)(41574002)(199003)(189002)(377454003)(479174003)(92726001)(2201001)(59896002)(87976001)(106356001)(102836001)(77096002)(107046002)(90102001)(105586002)(4396001)(85852003)(83072002)(64126003)(99396002)(92566001)(81542001)(50986999)(23756003)(77982001)(65816999)(85306004)(36756003)(95666004)(21056001)(76482001)(101416001)(74662001)(31966008)(74502001)(66066001)(80022001)(46102001)(65956001)(20776003)(83506001)(47776003)(97736003)(19580405001)(50466002)(54356999)(79102001)(87266999)(81342001)(76176999)(83322001)(33656002)(80316001)(19580395003)(42186005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB312;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 04:29 PM, Grant Likely wrote:
> On Wed, 27 Aug 2014 17:09:39 +0300, Laurentiu Tudor <b10716@freescale.com> wrote:
>> Simply swap of_alias and of_chosen initialization so
>> that of_alias ends up read first. This must be done
>> because it is accessed couple of lines below when
>> trying to initialize the of_stdout using the alias
>> based legacy method.
>>
>> [Fixes a752ee5 - tty: Update hypervisor tty drivers to                          
>> use core stdout parsing code]
>>
>> Signed-off-by: Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> ---
>>  drivers/of/base.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index d8574ad..52f8506 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1847,6 +1847,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>>  {
>>  	struct property *pp;
>>  
>> +	of_aliases = of_find_node_by_path("/aliases");
>> +	if (!of_aliases)
>> +		return;
>> +
>>  	of_chosen = of_find_node_by_path("/chosen");
>>  	if (of_chosen == NULL)
>>  		of_chosen = of_find_node_by_path("/chosen@0");
>> @@ -1862,10 +1866,6 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>>  			of_stdout = of_find_node_by_path(name);
>>  	}
>>  
>> -	of_aliases = of_find_node_by_path("/aliases");
>> -	if (!of_aliases)
>> -		return;
>> -
> 
> Close, but not quite. The 'if (!of_aliases)' test should not be moved.
> Only the search for of_find_node_by_path().

Eek, completely missed this. Sorry.

> I've fixed it up and applied.
 
Thanks!

---
Best Regards, Laurentiu
