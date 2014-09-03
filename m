Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaICNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:37:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48054 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaICNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:37:17 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-30-5407198abae0
Message-id: <540718DB.8060701@samsung.com>
Date: Wed, 03 Sep 2014 16:34:19 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 6/8] ima: remove unnecessary code
References: <cover.1409728712.git.d.kasatkin@samsung.com>
 <b698bd0778ead0491205b0fda4bf5ed6c67ecec3.1409728712.git.d.kasatkin@samsung.com>
 <1409749704.21827.66.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1409749704.21827.66.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xq7pdkuwhBgtfKlp8WVpn8XLGPHaL
	y7vmsFl86HnEZvFpxSRmB1aPnbPusns8OLSZxWP3gs9MHp83yQWwRHHZpKTmZJalFunbJXBl
	LLs7ha3gMW9F24v9jA2Mk7i7GDk5JARMJBbOXskOYYtJXLi3nq2LkYtDSGApo8SHe/+gnEYm
	iWNfXzJBOLMYJVpez2LuYuTg4BXQkjjZzwzSzSKgKrFgwk4wm01AT2JD8w+wqaICYRLPfh1k
	ArF5BQQlfky+xwJiiwhoShxr/cgIMpNZoJdRon9dH1izsICpxJxzr1gglp1ilPh5+S/YJE4B
	D4nlXw+DLWYWUJeYMiUXJMwsIC+xec1bsF4hoCO6165lg3hHUeL05HPMExiFZyHZPQuhexaS
	7gWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQuLhyw7GxcesDjEKcDAq8fAWqLGFCLEm
	lhVX5h5ilOBgVhLh1WRmDxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAGDSznEWugU/mePnDo5Md
	0nZOfbJhjvWW4C9W0/hVLyxZbGK+d9v3vWUSETKH807ftCtgyTxas+HIwQkcRV+0uCfse7l4
	w/Np9aJrJ8UnmGQvu50+2zBYTYAxTq+myMz4fP6Zy/fdliZnTzuxZurFkPyuiQG+e2Zt+7/e
	LktXg31JQffhRZOk/yqxFGckGmoxFxUnAgC7PV1AZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 16:08, Mimi Zohar wrote:
> On Wed, 2014-09-03 at 10:19 +0300, Dmitry Kasatkin wrote: 
>> If ima_appraise is 0, then action would not mandate to perform
>> appraisal and ima_appraise_measurement will never be called.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> The policy determines whether or not a file should be appraised.
> Whether IMA is configured and enabled to appraise files is a different
> issue.  The test is not done in process_measurement(), but deferred to
> here.

Hi,

Policy requests honors "ima_appraise" variable.
There wont be any appraisal action if 'ima_appraise' is disabled.

See bellow...

--------------------
int ima_get_action(struct inode *inode, int mask, int function)
{
        .........
        if (!ima_appraise)
                flags &= ~IMA_APPRAISE;
        ..........
--------------

- Dmitry
> Mimi
>
>> ---
>>  security/integrity/ima/ima_appraise.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
>> index 225fd94..013ec3f 100644
>> --- a/security/integrity/ima/ima_appraise.c
>> +++ b/security/integrity/ima/ima_appraise.c
>> @@ -192,8 +192,6 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>>  	enum integrity_status status = INTEGRITY_UNKNOWN;
>>  	int rc = xattr_len, hash_start = 0;
>>
>> -	if (!ima_appraise)
>> -		return 0;
>>  	if (!inode->i_op->getxattr)
>>  		return INTEGRITY_UNKNOWN;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

