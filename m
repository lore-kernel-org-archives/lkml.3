Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaICNzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:55:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30686 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaICNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:55:15 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1c-54071dc19485
Message-id: <54071D11.5000404@samsung.com>
Date: Wed, 03 Sep 2014 16:52:17 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Linux-ima-devel] [PATCH 8/8] ima: initialize only required
 template
References: <cover.1409728712.git.d.kasatkin@samsung.com>
 <ee009655866311106c98cdf87371d52f242782af.1409728712.git.d.kasatkin@samsung.com>
 <54071B91.4020404@polito.it>
In-reply-to: <54071B91.4020404@polito.it>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xa7oHZdlDDKaelLV4OWMeu8XlXXPY
	LD70PGKzeLnrG7vFpxWTmB1YPR4c2szisXvBZyaP0yuLPT5vkgtgieKySUnNySxLLdK3S+DK
	2Pu8uqBfqGL6wbNsDYyHebsYOTkkBEwk7j6+xwZhi0lcuLceyObiEBJYyigx4fwWdginkUli
	57J2FghnFqPEtQVvwVp4BbQk1n7YxghiswioSux78B3MZhPQk9jQ/IMdxBYVCJN49usgE0S9
	oMSPyffABokITGWUOHpgHzNIgllAQeLXvU2sILawQLDEnU/XGSG2rWaUeLl1L9hUTgFNiSub
	fwBt5gBq0JO4f1ELoldeYvOat2BzhICO6F67FuofRYnTk88xT2AUnoVk9yyE7llIuhcwMq9i
	FE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImHLzsYFx+zOsQowMGoxMNboMYWIsSaWFZcmXuI
	UYKDWUmEd400e4gQb0piZVVqUX58UWlOavEhRiYOTqkGxjXdi7ROLFs2KfnzM4sC/1uvLG66
	Nz1i5s+fn39kgnnwtj+MJ89tTDp/7+vu1uAcp8cP0qp8mYWqO9qWPL/GHjtrdsWdpDdS+gty
	lkbK+L/OiP/neGp6gr7CQR2h2kpxpo5fs99O01V1O91i2HHp0qyNcatCnno4zo/dcvn4orkW
	TdtZ13Z/a1FiKc5INNRiLipOBAASFCqRZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 16:45, Roberto Sassu wrote:
> On 09/03/2014 09:20 AM, Dmitry Kasatkin wrote:
>> IMA uses only one template. This patch initializes only required
>> template to avoid unnecessary memory allocations.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>   security/integrity/ima/ima_template.c | 28
>> ++++------------------------
>>   1 file changed, 4 insertions(+), 24 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_template.c
>> b/security/integrity/ima/ima_template.c
>> index f682606..e854862 100644
>> --- a/security/integrity/ima/ima_template.c
>> +++ b/security/integrity/ima/ima_template.c
>> @@ -152,24 +152,6 @@ out:
>>       return result;
>>   }
>>
>> -static int __init init_defined_templates(void)
>> -{
>> -    int i = 0;
>> -    int result = 0;
>> -
>> -    /* Init defined templates. */
>> -    for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
>> -        struct ima_template_desc *template = &defined_templates[i];
>> -
>> -        result = template_desc_init_fields(template->fmt,
>> -                           &(template->fields),
>> -                           &(template->num_fields));
>> -        if (result < 0)
>> -            return result;
>> -    }
>> -    return result;
>> -}
>> -
>>   struct ima_template_desc *ima_template_desc_current(void)
>>   {
>>       if (!ima_template)
>> @@ -180,11 +162,9 @@ struct ima_template_desc
>> *ima_template_desc_current(void)
>>
>>   int __init ima_init_template(void)
>>   {
>> -    int result;
>> -
>> -    result = init_defined_templates();
>> -    if (result < 0)
>> -        return result;
>> +    struct ima_template_desc *template = ima_template_desc_current();
>>
>> -    return 0;
>> +    return template_desc_init_fields(template->fmt,
>> +                     &(template->fields),
>> +                     &(template->num_fields));
>
> Hi Dmitry
>
> ok, I'm fine with the change even if the template
> initialization routine will be used for other purposes
> (array items will be added in a linked list to permit
> templates dynamic registration).
>
> Thanks
>
> Roberto Sassu
>

Hi Roberto,

Welcome back from holidays.

Sure, initialization function can be used later as well..

- Dmitry

>
>>   }
>>
>
>

