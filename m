Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaFIIpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:45:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27286 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaFIIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:45:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-60-539574349c2c
Message-id: <53957420.3080709@samsung.com>
Date: Mon, 09 Jun 2014 11:45:20 +0300
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
Subject: Re: [RFC PATCH v5 3/4] ima: define '.ima' as a builtin 'trusted'
 keyring
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1401818318-15780-4-git-send-email-zohar@linux.vnet.ibm.com>
 <CACE9dm_o6RLvn9vP9X9BXGB1mFjC3Y7G15dZKqGsh+iZ3cFy5Q@mail.gmail.com>
 <1402097230.11626.73.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402097230.11626.73.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7omJVODDVq7FC3eNf1msfiytM7i
	wLsnLBazdz1ksbi8aw6bxYeeR2wWn1ZMYnZg99g56y67x7QTy1g8HhzazOLxft9VNo/Pm+QC
	WKO4bFJSczLLUov07RK4Ml7P3cpYsNq8YkpnbQPjBa0uRk4OCQETiRcfpjNC2GISF+6tZwOx
	hQSWMkqseyPUxcgFZDcySSy5t5UdwpnFKPH65EpWkCpeAS2J1y/esIPYLAKqEte+rGcCsdkE
	9CQ2NP8AinNwiApESDy+IARRLijxY/I9FhBbBCh8aM8pFpCZzAK3GSVeHjwMtllYIFji+spJ
	bBDLepgkHvYsAVvAKeAh0XjoJlg3s4C6xKR5i5ghbHmJzWveMkOcrSrRvXYtG8Q7ihKnJ59j
	nsAoPAvJ8llI2mchaV/AyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRavu5gXHrM6hCj
	AAejEg9vAtPUYCHWxLLiytxDjBIczEoivD45QCHelMTKqtSi/Pii0pzU4kOMTBycUg2M2s8F
	qvdudz21W1JQIE3z8Gq1Vexh1qWtp35OsZATWXvr2OpDcp1n5oZWfL+gtVOFf1JzkPy024f4
	HQ4suiW/4v+LBy3/v686Ze1vtv7NiSt/JctvXp6yjOuUla+JSSW/huCLB0GvzbX0Nx9OWHTu
	x8qanwq/n/BEvetJaYtQOSmrfuu3/g//HiWW4oxEQy3mouJEAG504wd0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/14 02:27, Mimi Zohar wrote:
> On Sat, 2014-06-07 at 00:53 +0300, Dmitry Kasatkin wrote: 
>> On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>> Require all keys added to the IMA keyring be signed by an
>>> existing trusted key on the system trusted keyring.
>>>
>>> Changelog v5:
>>> - Move integrity_init_keyring() to init_ima() - Dmitry
>>> - reset keyring[id] on failure - Dmitry
>>>
>>> Changelog v1:
>>> - don't link IMA trusted keyring to user keyring
>>>
>>> Changelog:
>>> - define stub integrity_init_keyring() function (reported-by Fengguang Wu)
>>> - differentiate between regular and trusted keyring names.
>>> - replace printk with pr_info (D. Kasatkin)
>>> - only make the IMA keyring a trusted keyring (reported-by D. Kastatkin)
>>> - define stub integrity_init_keyring() definition based on
>>>   CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.
>>>   (reported-by Jim Davis)
>>>
>>> Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
>>> ---
>>>  security/integrity/digsig.c       | 26 ++++++++++++++++++++++++++
>>>  security/integrity/ima/Kconfig    |  8 ++++++++
>>>  security/integrity/ima/ima_main.c | 12 ++++++++++--
>>>  security/integrity/integrity.h    |  5 +++++
>>>  4 files changed, 49 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>>> index b4af4eb..fa4c2fd 100644
>>> --- a/security/integrity/digsig.c
>>> +++ b/security/integrity/digsig.c
>>> @@ -13,7 +13,9 @@
>>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>
>>>  #include <linux/err.h>
>>> +#include <linux/sched.h>
>>>  #include <linux/rbtree.h>
>>> +#include <linux/cred.h>
>>>  #include <linux/key-type.h>
>>>  #include <linux/digsig.h>
>>>
>>> @@ -24,7 +26,11 @@ static struct key *keyring[INTEGRITY_KEYRING_MAX];
>>>  static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>>         "_evm",
>>>         "_module",
>>> +#ifndef CONFIG_IMA_TRUSTED_KEYRING
>>>         "_ima",
>>> +#else
>>> +       ".ima",
>>> +#endif
>>>  };
>>>
>>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>> @@ -56,3 +62,23 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>>
>>>         return -EOPNOTSUPP;
>>>  }
>>> +
>>> +int integrity_init_keyring(const unsigned int id)
>>> +{
>>> +       const struct cred *cred = current_cred();
>>> +
>>> +       keyring[id] = keyring_alloc(keyring_name[id], KUIDT_INIT(0),
>>> +                                   KGIDT_INIT(0), cred,
>>> +                                   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
>>> +                                     KEY_USR_VIEW | KEY_USR_READ |
>>> +                                     KEY_USR_WRITE | KEY_USR_SEARCH),
>>> +                                   KEY_ALLOC_NOT_IN_QUOTA, NULL);
>>> +       if (!IS_ERR(keyring[id]))
>>> +               set_bit(KEY_FLAG_TRUSTED_ONLY, &keyring[id]->flags);
>>> +       else {
>>> +               pr_info("Can't allocate %s keyring (%ld)\n",
>>> +                       keyring_name[id], PTR_ERR(keyring[id]));
>>> +               keyring[id] = NULL;
>>> +       }
>>> +       return 0;
>>> +}
>>> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
>>> index 81a2797..dad8d4c 100644
>>> --- a/security/integrity/ima/Kconfig
>>> +++ b/security/integrity/ima/Kconfig
>>> @@ -123,3 +123,11 @@ config IMA_APPRAISE
>>>           For more information on integrity appraisal refer to:
>>>           <http://linux-ima.sourceforge.net>
>>>           If unsure, say N.
>>> +
>>> +config IMA_TRUSTED_KEYRING
>>> +       bool "Require all keys on the _ima keyring be signed"
>>> +       depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
>>> +       default y
>>> +       help
>>> +          This option requires that all keys added to the _ima
>>> +          keyring be signed by a key on the system trusted keyring.
>>> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
>>> index 09baa33..4c60cc5 100644
>>> --- a/security/integrity/ima/ima_main.c
>>> +++ b/security/integrity/ima/ima_main.c
>>> @@ -328,8 +328,16 @@ static int __init init_ima(void)
>>>
>>>         hash_setup(CONFIG_IMA_DEFAULT_HASH);
>>>         error = ima_init();
>>> -       if (!error)
>>> -               ima_initialized = 1;
>>> +       if (error)
>>> +               goto out;
>>> +
>>> +#ifdef CONFIG_IMA_TRUSTED_KEYRING
>>> +       error = integrity_init_keyring(INTEGRITY_KEYRING_IMA);
>>> +       if (error)
>>> +               goto out;
>>> +#endif
>> integrity_init_keyring() has variation in header file...
>> Why do you need #ifdef in .c file? You you usually do not like it...
> Up to now, unsigned certificates could be added to the IMA keyring.  We
> can not all of a sudden require all keys being added to the IMA keyring
> to be signed.  Although there is a stub integrity_init_keyring()
> function definition, it is based on CONFIG_INTEGRITY_SIGNATURE, not
> CONFIG_IMA_TRUSTED_KEYRING.
>
> Right, ifdef's don't belong in C code.  One solution would be to define
> ima_init_keyring() as a wrapper for integrity_init_keyring() and a stub
> function.
>
> Mimi

I think 'ima_init_keyring" could be a good approach.

>From other hand, if you look to kernel/module.c, then you will find ~40
#ifdefs of the source code...

So it may be indeed clear from __init point of view what we initialize
and what not...

- Dmitry


>>> +       ima_initialized = 1;
>>> +out:
>>>         return error;
>>>  }
>>>
>>> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
>>> index 33c0a70..09c440d 100644
>>> --- a/security/integrity/integrity.h
>>> +++ b/security/integrity/integrity.h
>>> @@ -124,6 +124,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>>                             const char *digest, int digestlen);
>>>
>>> +int integrity_init_keyring(const unsigned int id);
>>>  #else
>>>
>>>  static inline int integrity_digsig_verify(const unsigned int id,
>>> @@ -133,6 +134,10 @@ static inline int integrity_digsig_verify(const unsigned int id,
>>>         return -EOPNOTSUPP;
>>>  }
>>>
>>> +static inline int integrity_init_keyring(const unsigned int id)
>>> +{
>>> +       return 0;
>>> +}
>>>  #endif /* CONFIG_INTEGRITY_SIGNATURE */
>>>
>>>  #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>>> --
>>> 1.8.1.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

