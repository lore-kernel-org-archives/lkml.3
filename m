Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab3FEVz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:55:58 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:55875
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850Ab3FEVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:55:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I103dK1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNXWX1-02-KAQ-02
X-M-MSG: 
Message-ID: <51AFB3DC.10308@amd.com>
Date: Wed, 5 Jun 2013 16:55:40 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <bp@suse.de>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Add code to handle new MCE signatures for new models
 of Fam15h
References: <1370465403-2370-1-git-send-email-aravind.gopalakrishnan@amd.com> <20130605213249.GD29856@pd.tnic>
In-Reply-To: <20130605213249.GD29856@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2013 4:32 PM, Borislav Petkov wrote:
> On Wed, Jun 05, 2013 at 03:50:03PM -0500, Aravind Gopalakrishnan wrote:
>> There are some newer error signatures in Family 15h models 30h-3fh.
>> Code has been added in the patch to support these new signatures.
>>
>> Patch has been tested on Fam15h using mce_amd_inj facility and
>> has been verified to work correctly.
>>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>>   drivers/edac/mce_amd.c |    5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
>> index f3f0c93..9de24c7 100644
>> --- a/drivers/edac/mce_amd.c
>> +++ b/drivers/edac/mce_amd.c
>> @@ -134,7 +134,8 @@ static const char * const mc5_mce_desc[] = {
>>   	"Physical register file AG0 port",
>>   	"Physical register file AG1 port",
>>   	"Flag register file",
>> -	"DE error occurred"
>> +	"DE error occurred",
>> +	"Retire Status Queue Parity"
> Since "parity error" is already in the printk below, I'm guessing this
> string should be "Retire status queue" only?

     Okay, that should convey the message too...

> No need to resend the patch, btw - I'll fix it up when applying.

     Thanks!

>>   };
>>   
>>   static bool f12h_mc0_mce(u16 ec, u8 xec)
>> @@ -624,7 +625,7 @@ static void decode_mc5_mce(struct mce *m)
>>   
>>   	if (xec == 0x0 || xec == 0xc)
>>   		pr_cont("%s.\n", mc5_mce_desc[xec]);
>> -	else if (xec < 0xd)
>> +	else if (xec <= 0xd)
>>   		pr_cont("%s parity error.\n", mc5_mce_desc[xec]);
>>   	else
>>   		goto wrong_mc5_mce;
- Aravind.

