Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaFILnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:43:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53466 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaFILnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:43:40 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-20-53959de9dbc7
Message-id: <53959DD4.6010306@samsung.com>
Date: Mon, 09 Jun 2014 14:43:16 +0300
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
Subject: Re: [RFC PATCH v4 3/4] ima: define '.ima' as a builtin 'trusted'
 keyring
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401289784-31340-4-git-send-email-zohar@linux.vnet.ibm.com>
 <CACE9dm8K8Qs_p3fcsW2m9h-M+iX7m=F=hbTeUeyi4vp_Pq7k0g@mail.gmail.com>
 <1401305182.13546.152.camel@dhcp-9-2-203-236.watson.ibm.com>
 <CACE9dm8f+nxvY+R1j0+n9wWqc2yCspOrfR4ZXhEyOPzPHXOJqA@mail.gmail.com>
 <1402311976.7064.5.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402311976.7064.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xa7ov504NNrj/w9jiXdNvFosvS+ss
	Drx7wmIxe9dDFovLu+awWXzoecRm8WnFJGYHdo+ds+6ye0w7sYzF48GhzSwe7/ddZfP4vEku
	gDWKyyYlNSezLLVI3y6BK+PE+UvMBVc0KiY3bWZuYDwq38XIySEhYCKxcd1WFghbTOLCvfVs
	XYxcHEICSxklfn84xAqSEBJoZJJY9EcRIjGLUWJz6wygKg4OXgEtiU/NXiA1LAKqEp/W7mYD
	sdkE9CQ2NP9gBykRFYiQeHxBCCTMKyAo8WPyPbBdIkDhQ3tOsYCMZBa4zSjx8uBhsF5hgWCJ
	rjPnGCF2TWCW2Df9MFgHp4CbxLxvl5hAbGYBdYlJ8xYxQ9jyEpvXvGWGOFRVonvtWjaIbxQl
	Tk8+xzyBUXgWkuWzkLTPQtK+gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZItHzZwbj4
	mNUhRgEORiUe3gzOqcFCrIllxZW5hxglOJiVRHh9coBCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GF1/v2L44HGJj+fS5l/LrHaKTO0Q5LefuszxTNlMN+doqzlGRWkppqWJS7drKX+TebBQev+0
	3QmvmdMmbDpRceSo2B9Bb/lM9tnHOCMzEvmLHp7eY3bu+E0pLwlfiUuTz908spTnYoSPuNwO
	1caQF1s6TWtm60h+4Dz78uGN608VjzqF6U+fxanEUpyRaKjFXFScCAA2Ko6UdAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 14:06, Mimi Zohar wrote:
> On Fri, 2014-05-30 at 19:05 +0300, Dmitry Kasatkin wrote:
>> On 28 May 2014 22:26, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>> On Wed, 2014-05-28 at 21:55 +0300, Dmitry Kasatkin wrote:
>>>> On 28 May 2014 18:09, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>>>> Require all keys added to the IMA keyring be signed by an
>>>>> existing trusted key on the system trusted keyring.
>>>>>
>>>>> Changelog v1:
>>>>> - don't link IMA trusted keyring to user keyring
>>>>>
>>>>> Changelog:
>>>>> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
>>>>> - differentiate between regular and trusted keyring names.
>>>>> - replace printk with pr_info (D. Kasatkin)
>>>>> - only make the IMA keyring a trusted keyring (reported-by D. Kastatkin)
>>>>> - define stub integrity_init_keyring() definition based on
>>>>>   CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.
>>>>>   (reported-by Jim Davis)
>>>>>
>>>>> Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
>>>>> ---
>>>>>  security/integrity/digsig.c           | 26 +++++++++++++++++++++++++-
>>>>>  security/integrity/ima/Kconfig        |  8 ++++++++
>>>>>  security/integrity/ima/ima_appraise.c | 11 +++++++++++
>>>>>  security/integrity/integrity.h        |  5 +++++
>>>>>  4 files changed, 49 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>>>>> index b4af4eb..7da5f9c 100644
>>>>> --- a/security/integrity/digsig.c
>>>>> +++ b/security/integrity/digsig.c
>>>>> @@ -13,7 +13,9 @@
>>>>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>>>
>>>>>  #include <linux/err.h>
>>>>> +#include <linux/sched.h>
>>>>>  #include <linux/rbtree.h>
>>>>> +#include <linux/cred.h>
>>>>>  #include <linux/key-type.h>
>>>>>  #include <linux/digsig.h>
>>>>>
>>>>> @@ -24,7 +26,11 @@ static struct key *keyring[INTEGRITY_KEYRING_MAX];
>>>>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>>>>         "_evm",
>>>>>         "_module",
>>>>> +#ifndef CONFIG_IMA_TRUSTED_KEYRING
>>>>>         "_ima",
>>>>> +#else
>>>>> +       ".ima",
>>>>> +#endif
>>>>>  };
>>>>>
>>>>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>>>> @@ -35,7 +41,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>>>>
>>>>>         if (!keyring[id]) {
>>>>>                 keyring[id] =
>>>>> -                       request_key(&key_type_keyring, keyring_name[id], NULL);
>>>>> +                   request_key(&key_type_keyring, keyring_name[id], NULL);
>>>>>                 if (IS_ERR(keyring[id])) {
>>>>>                         int err = PTR_ERR(keyring[id]);
>>>>>                         pr_err("no %s keyring: %d\n", keyring_name[id], err);
>>>>> @@ -56,3 +62,21 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>>>>
>>>>>         return -EOPNOTSUPP;
>>>>>  }
>>>>> +
>>>>> +int integrity_init_keyring(const unsigned int id)
>>>>> +{
>>>>> +       const struct cred *cred = current_cred();
>>>>> +
>>>>> +       keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
>>>>> +                                   KGIDT_INIT(0), cred,
>>>>> +                                   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
>>>>> +                                     KEY_USR_VIEW | KEY_USR_READ |
>>>>> +                                     KEY_USR_WRITE | KEY_USR_SEARCH),
>>>>> +                                   KEY_ALLOC_NOT_IN_QUOTA, NULL);
>>>> Last parameter "destination" is NULL. It makes keyring "unsearchable"
>>>> from user space.
>>>> It prevents loading trusted keys from user-space, e.g. initramfs...
>>>>
>>>> Should it be "cred->user->uid_keyring"??
>>> David extended keyctl with the '%keyring' option.  For example,
>>> "keyctl show %keyring:.ima" returns the .ima keyring id with a list of
>>> all the keys.
>>>
>> That is not kernel feature, but keyctl feature as I can see.
>> It will not find keyring from user space..
>>
>> keyutils.c 3.5.7 has this kind of thing
>> f = fopen("/proc/keys", "r");
>>
>> But it would require CONFIG_PROC_KEYS to be enabled.
>>
>> May be David may comment...
> David commented on an prior patch set, which defined a new id for the
> system trusted keyring. For hjs comments, refer to
> http://marc.info/?l=linux-security-module&m=137829415530503&w=2
>
> thanks,
>
> Mimi

Fine for me if such API is fine for David.

I just checked one again. They option to enable /proc/keys is called
CONFIG_KEYS_DEBUG_PROC_KEYS

It is a bit weired that in order to be able to load keys to trusted
keyring it is necessary to enable *_DEBUG_* option.

David stated: (1) Make /proc/keys always present if CONFIG_KEYS=y.

It is not there yet...

Should than CONFIG_IMA_TRUSTED_KEYRING "select
CONFIG_KEYS_DEBUG_PROC_KEYS" by David suggestion?

- Dmitry

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

