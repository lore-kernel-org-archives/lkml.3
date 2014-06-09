Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaFIIRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:17:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25615 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaFIIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:17:31 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1b-53956d986972
Message-id: <53956D84.5050100@samsung.com>
Date: Mon, 09 Jun 2014 11:17:08 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 1/4] KEYS: special dot prefixed keyring name bug fix
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401818318-15780-2-git-send-email-zohar@linux.vnet.ibm.com>
 <CACE9dm909SGRBOybkh8z8jNiGPc_ksKHzsMuvNB+ro9furQ_tQ@mail.gmail.com>
 <1402092031.11626.35.camel@dhcp-9-2-203-236.watson.ibm.com>
 <539568B6.2070603@samsung.com>
In-reply-to: <539568B6.2070603@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xK7ozcqcGG0xYY2rxruk3i8WXpXUW
	B949YbGYveshi8XlXXPYLD70PGKz+LRiErMDu8fOWXfZPaadWMbi8eDQZhaP9/uusnl83iQX
	wBrFZZOSmpNZllqkb5fAldHx8xJTQaNoRcvGQ+wNjOv4uxg5OSQETCSe3P7DDmGLSVy4t56t
	i5GLQ0hgKaPEhEdzWCGcRiaJOQ2H2SGcWYwSv9vPg7XwCmhJPNp2A6iFg4NFQFXi8vVakDCb
	gJ7EhuYf7CBhUYEIiccXhCCqBSV+TL7HAmKLAIUP7TnFAjKSWeA2o8TLg4fZQBLCAv4SPdNW
	Ql2xlkni6Z7bTCAJTgFtiZO3DzOD2MwC6hKT5i2CsuUlNq95C2YLAd3QvXYtG8Q7ihKnJ59j
	nsAoPAvJ8llI2mchaV/AyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyRevuxgXHzM6hCj
	AAejEg9vBufUYCHWxLLiytxDjBIczEoivD45QCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mft8d
	d3jOelnrarpvupCoVKxIsaDJhvjlBn9e9TKE6M0ta0yL67NKPXc8aHFXxY2kW5P+BgfI7Ex9
	9eyU0Ddb+6gTd3nLNlscWTuPQ8vph0HLbB5bPo/uY0HXam5N6K3jdE5l8G4Rs1TNk1v3e9Oz
	K/s/2Ce3nVji4KPUqMcWHbRwm+5iYQclluKMREMt5qLiRACg4erZdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 10:56, Dmitry Kasatkin wrote:
> On 07/06/14 01:00, Mimi Zohar wrote:
>> On Sat, 2014-06-07 at 00:48 +0300, Dmitry Kasatkin wrote: 
>>> On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>>> Dot prefixed keyring names are supposed to be reserved for the
>>>> kernel, but add_key() calls key_get_type_from_user(), which
>>>> incorrectly verifies the 'type' field, not the 'description' field.
>>>> This patch verifies the 'description' field isn't dot prefixed,
>>>> when creating a new keyring, and removes the dot prefix test in
>>>> key_get_type_from_user().
>>>>
>>>> Changelog v5:
>>>> - Only prevent userspace from creating a dot prefixed keyring, not
>>>>   regular keys  - Dmitry
>>>>
>>>> Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>>>> Cc: David Howells <dhowells@redhat.com>
>>>> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>>>> ---
>>>>  security/keys/keyctl.c | 6 ++++--
>>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
>>>> index cd5bd0c..62a9952 100644
>>>> --- a/security/keys/keyctl.c
>>>> +++ b/security/keys/keyctl.c
>>>> @@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
>>>>                 return ret;
>>>>         if (ret == 0 || ret >= len)
>>>>                 return -EINVAL;
>>>> -       if (type[0] == '.')
>>>> -               return -EPERM;
>>>>         type[len - 1] = '\0';
>>>>         return 0;
>>>>  }
>>>> @@ -86,6 +84,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
>>>>                 if (!*description) {
>>>>                         kfree(description);
>>>>                         description = NULL;
>>>> +               } else if ((description[0] == '.') &&
>>>> +                          (strncmp(type, "keyring", 7) == 0)) {

BTW. using strcmp is good enough here. string constants are always NULL
terminated.
Comparison will terminate after no more than 7 bytes.


>>>> +                               ret = -EPERM;
>>>> +                               goto error2;
>>>>                 }
>>>>         }
>>> I think it does not another problem...
>>> It is not only prevent creating new keyring with ".abc" name but also
>>> prevent adding new key...
>>>
>>> this is wrong...
>> Seems to prevent creating a dot prefixed keyring, but permits creating a
>> dot prefixed key.  Do you have an example?
> I think by mistake I was checking old patch in the thread because I have
> not noticed strncmp(type, "keyring", 7).
> This patch definitely should do the job.
>
> - Dmitry
>
>
>> thanks,
>>
>> Mimi
>>
>> Mimi
>>
>>
>>

