Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaDYP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:58:34 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:32642
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434AbaDYP6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:58:32 -0400
Message-ID: <535A860E.4000007@caviumnetworks.com>
Date: Fri, 25 Apr 2014 08:58:06 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Nicolas Del Piano <ndel314@gmail.com>
CC: <devel@driverdev.osuosl.org>, <david.daney@cavium.com>,
        <raluca.oncioiu91@gmail.com>, <linux-kernel@vger.kernel.org>,
        <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] Staging: octeon-usb: fixed a macro coding style issue
References: <1398433702-2931-1-git-send-email-ndel314@gmail.com> <20140425142133.GA14201@kroah.com>
In-Reply-To: <20140425142133.GA14201@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0192E812EC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(24454002)(51704005)(189002)(199002)(377454003)(479174003)(65816999)(53416003)(19580405001)(83506001)(81542001)(46102001)(19580395003)(551934002)(74662001)(74502001)(50466002)(36756003)(23756003)(31966008)(79102001)(64126003)(81342001)(80976001)(65956001)(92726001)(33656001)(99396002)(80022001)(4396001)(87936001)(76482001)(85852003)(47776003)(83072002)(66066001)(65806001)(83322001)(92566001)(50986999)(87266999)(76176999)(77982001)(59896001)(20776003)(54356999)(3076001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB929;H:BLUPRD0711HT003.namprd07.prod.outlook.com;FPR:3C10F2BE.ACFAD7C5.31F0634E.467ED2D1.202CB;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 07:21 AM, Greg KH wrote:
> On Fri, Apr 25, 2014 at 10:48:22AM -0300, Nicolas Del Piano wrote:
>> Fixed a coding style error, macros with complex values should be enclosed in parentheses.
>>
>> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
>> ---
>>   drivers/staging/octeon-usb/octeon-hcd.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
>> index 8b8ce72..ef3a8ce 100644
>> --- a/drivers/staging/octeon-usb/octeon-hcd.c
>> +++ b/drivers/staging/octeon-usb/octeon-hcd.c
>> @@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
>>   };
>>
>>   /* Normal prefetch that use the pref instruction. */
>> -#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
>> +#define CVMX_PREFETCH(address, offset) (asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))
>>
>>   /* Maximum number of times to retry failed transactions */
>>   #define MAX_RETRIES		3
>
> Will that actually compile?

No it does not.  Really when changing things like this, you should first 
understand what it is doing.  In the case of this patch, I don't think 
that understanding was present.

It appears that in the case of this patch, Documentation/SubmitChecklist 
was not consulted.  In particular item #2(all sections) was omitted.

Q: Why did I have to waste 15 minutes of my day on this?  Is the patch 
subimtter's time so valuable that standard patch submittal procedures 
cannot be followed?

>
> Why the heck are we using asm in a define in the first place?  Shouldn't
> this be an inline function or something?

You are correct.  It turns out that <linux/prefetch.h> already has such 
a definition.

>
> thanks,
>
> greg k-h
>

