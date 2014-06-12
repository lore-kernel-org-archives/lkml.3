Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaFLRYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:24:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59927 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbaFLRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:24:27 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-23-5399e247ed74
Message-id: <5399E22D.9070205@samsung.com>
Date: Thu, 12 Jun 2014 20:23:57 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        mjg59@srcf.ucam.org
Subject: Re: [PATCH 3/4] KEYS: validate key trust only with selected owner key
References: <cover.1402387862.git.d.kasatkin@samsung.com>
 <ef22f2630a2545bd7c3bf2c9e730a842835cf6c4.1402387862.git.d.kasatkin@samsung.com>
 <20140612160346.GG9578@redhat.com>
In-reply-to: <20140612160346.GG9578@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xK7ruj2YGG6w7bWHxruk3i8WXpXUW
	B949YbGYveshi8XlXXPYLD70PGKzuPpwNovFtVv72Cw+rZjE7MDpsXPWXXaPaSeWsXg8OLSZ
	xeP9vqtsHutufGX3+LxJLoAtissmJTUnsyy1SN8ugSvj/OStrAXvvCumLzjD2sA40baLkZND
	QsBEom/NY1YIW0ziwr31bF2MXBxCAksZJY5t72KCcBqZJB7Nm8oK4cxilJjxaSY7SAuvgJZE
	07I1TCA2i4CqxLuFP1hAbDYBPYkNzT+Aajg4RAUiJB5fEIIoF5T4MfkeC0hYREBZ4va7QJCR
	zALXGCV+bIQYKSzgJ/Hs0zaoXRsZJU7fPwh2HqeAvsS3o88YQWxmAR2J/a3T2CBseYnNa94y
	g9hCQDd0r13LBvGOosTpyeeYJzAKz0KyexaS9llI2hcwMq9iFE0tTS4oTkrPNdIrTswtLs1L
	10vOz93ECImmrzsYlx6zOsQowMGoxMOr+XpGsBBrYllxZe4hRgkOZiUR3v+3ZwYL8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYEwMi07Sj49bUdbFqD3/Tq7+vht8aoqPzSKd4uUkfj+ZNNP1nIjN
	OeMK7vMv/YSlFL/bXVj+N2/WnAUrGGWlmLZ82DCFuf1MXNpLrawk04O2r+bP2LzGzyTpVXli
	xcrVjFMXhRS7qX9pmJmxSiRB6MJG783/5r8TcZc5krHW+uHNiWvfnjGZckaJpTgj0VCLuag4
	EQC0akrNhAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/14 19:03, Vivek Goyal wrote:
> On Tue, Jun 10, 2014 at 11:48:17AM +0300, Dmitry Kasatkin wrote:
>> This patch provides kernel parameter to specify owner's key id which
>> must be used for trust validate of keys. Keys signed with other keys
>> are not trusted.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Hi,
>
> I am continuing to work on verifying kernel signature for kexec/kdump. I 
> am planning to take david howell's patches for pkcs7 signature
> verification and verify bzImage signature.
>
> Part of that process will boil down to verifying a certificate in
> pkcs7 x509 cert chain using a key in system_trusted_keyring.
>
> I think the OS vendor key which signs the kernel signing key propagates to
> system_trusted_keyring. (shim has that and I am not sure how shim makes
> it propogate all they way to system_trusted_keyring).
>
> So I was planning to use same functionality where I look for any key
> which can verify the signing cert of kernel. As OS vendor key will be
> in system_trusted_keyring, it should work.
>
> Now with this change where you will trust only one selected owner key.
> That means you will not even trust the OS vendor key which signs kernel
> signing key. I think this will stop working with  keys_ownerid=<....>
>
> As I am doing that work in parallel and I saw these patches, I thought
> I will bring it up.

Hi Vivek,

All keys stays in the keyring. Usage of owner_keyid is limited to
validate the trust of the loaded keys.


Do you really see OS verndor key (Fedora) on the system keyring?
shim is UEFI binary and can add it to the MOK database..

- Dmitry


> Thanks
> Vivek
>
>> ---
>>  crypto/asymmetric_keys/x509_public_key.c | 27 ++++++++--
>>  include/keys/owner_keyring.h             | 27 ----------
>>  init/Kconfig                             | 10 ----
>>  kernel/Makefile                          |  1 -
>>  kernel/owner_keyring.c                   | 85 --------------------------------
>>  5 files changed, 24 insertions(+), 126 deletions(-)
>>  delete mode 100644 include/keys/owner_keyring.h
>>  delete mode 100644 kernel/owner_keyring.c
>>
>> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
>> index 962f9b9..d46b790 100644
>> --- a/crypto/asymmetric_keys/x509_public_key.c
>> +++ b/crypto/asymmetric_keys/x509_public_key.c
>> @@ -19,12 +19,24 @@
>>  #include <keys/asymmetric-subtype.h>
>>  #include <keys/asymmetric-parser.h>
>>  #include <keys/system_keyring.h>
>> -#include <keys/owner_keyring.h>
>>  #include <crypto/hash.h>
>>  #include "asymmetric_keys.h"
>>  #include "public_key.h"
>>  #include "x509_parser.h"
>>  
>> +static char *owner_keyid;
>> +static int __init default_owner_keyid_set(char *str)
>> +{
>> +	if (!str)		/* default system keyring */
>> +		return 1;
>> +
>> +	if (strncmp(str, "id:", 3) == 0)
>> +		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
>> +
>> +	return 1;
>> +}
>> +__setup("keys_ownerid=", default_owner_keyid_set);
>> +
>>  /*
>>   * Find a key in the given keyring by issuer and authority.
>>   */
>> @@ -170,6 +182,16 @@ static int x509_validate_trust(struct x509_certificate *cert,
>>  	if (!trust_keyring)
>>  		return -EOPNOTSUPP;
>>  
>> +	if (owner_keyid) {
>> +		/* validate trust only with the owner_keyid if specified */
>> +		/* partial match of keyid according to the asymmetric_type.c */
>> +		int idlen = strlen(owner_keyid) - 3; /* - id: */
>> +		int authlen = strlen(cert->authority);
>> +		char *auth = cert->authority + authlen - idlen;
>> +		if (idlen > authlen || strcasecmp(owner_keyid + 3, auth))
>> +			return -EPERM;
>> +	}
>> +
>>  	key = x509_request_asymmetric_key(trust_keyring,
>>  					  cert->issuer, strlen(cert->issuer),
>>  					  cert->authority,
>> @@ -239,8 +261,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>>  		if (ret < 0)
>>  			goto error_free_cert;
>>  	} else if (!prep->trusted) {
>> -		ret = x509_validate_trust(cert,
>> -					  get_system_or_owner_trusted_keyring());
>> +		ret = x509_validate_trust(cert, get_system_trusted_keyring());
>>  		if (!ret)
>>  			prep->trusted = 1;
>>  	}
>> diff --git a/include/keys/owner_keyring.h b/include/keys/owner_keyring.h
>> deleted file mode 100644
>> index 78dd09d..0000000
>> --- a/include/keys/owner_keyring.h
>> +++ /dev/null
>> @@ -1,27 +0,0 @@
>> -/* 
>> - * Copyright (C) 2014 IBM Corporation
>> - * Author: Mimi Zohar <zohar@us.ibm.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License as published by
>> - * the Free Software Foundation, version 2 of the License.
>> - */
>> -
>> -#ifndef _KEYS_OWNER_KEYRING_H
>> -#define _KEYS_OWNER_KEYRING_H
>> -
>> -#ifdef CONFIG_OWNER_TRUSTED_KEYRING
>> -
>> -#include <linux/key.h>
>> -
>> -extern struct key *owner_trusted_keyring;
>> -extern struct key *get_system_or_owner_trusted_keyring(void);
>> -
>> -#else
>> -static inline struct key *get_system_or_owner_trusted_keyring(void)
>> -{
>> -	return get_system_trusted_keyring();
>> -}
>> -
>> -#endif
>> -#endif /* _KEYS_OWNER_KEYRING_H */
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 7876787..009a797 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1661,16 +1661,6 @@ config SYSTEM_TRUSTED_KEYRING
>>  
>>  	  Keys in this keyring are used by module signature checking.
>>  
>> -config OWNER_TRUSTED_KEYRING
>> -	bool "Verify certificate signatures using a specific system key"
>> -	depends on SYSTEM_TRUSTED_KEYRING
>> -	help
>> -	  Verify a certificate's signature, before adding the key to
>> -	  a trusted keyring, using a specific key on the system trusted
>> -	  keyring.  The specific key on the system trusted keyring is
>> -	  identified using the kernel boot command line option
>> -	  "keys_ownerid" and is added to the owner_trusted_keyring.
>> -
>>  menuconfig MODULES
>>  	bool "Enable loadable module support"
>>  	option modules
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 7b44efd..bc010ee 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -44,7 +44,6 @@ obj-$(CONFIG_UID16) += uid16.o
>>  obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
>>  obj-$(CONFIG_MODULES) += module.o
>>  obj-$(CONFIG_MODULE_SIG) += module_signing.o
>> -obj-$(CONFIG_OWNER_TRUSTED_KEYRING) += owner_keyring.o
>>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>>  obj-$(CONFIG_KEXEC) += kexec.o
>> diff --git a/kernel/owner_keyring.c b/kernel/owner_keyring.c
>> deleted file mode 100644
>> index a31b865..0000000
>> --- a/kernel/owner_keyring.c
>> +++ /dev/null
>> @@ -1,85 +0,0 @@
>> -/* 
>> - * Copyright (C) 2014 IBM Corporation
>> - * Author: Mimi Zohar <zohar@us.ibm.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License as published by
>> - * the Free Software Foundation, version 2 of the License.
>> - */
>> -
>> -#include <linux/export.h>
>> -#include <linux/kernel.h>
>> -#include <linux/sched.h>
>> -#include <linux/cred.h>
>> -#include <linux/err.h>
>> -#include <keys/asymmetric-type.h>
>> -#include <keys/system_keyring.h>
>> -#include "module-internal.h"
>> -
>> -struct key *owner_trusted_keyring;
>> -static int use_owner_trusted_keyring;
>> -
>> -static char *owner_keyid;
>> -static int __init default_owner_keyid_set(char *str)
>> -{
>> -	if (!str)		/* default system keyring */
>> -		return 1;
>> -
>> -	if (strncmp(str, "id:", 3) == 0)
>> -		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
>> -
>> -	return 1;
>> -}
>> -
>> -__setup("keys_ownerid=", default_owner_keyid_set);
>> -
>> -struct key *get_system_or_owner_trusted_keyring(void)
>> -{
>> -	return use_owner_trusted_keyring ? owner_trusted_keyring :
>> -	    get_system_trusted_keyring();
>> -}
>> -
>> -static __init int owner_trusted_keyring_init(void)
>> -{
>> -	pr_notice("Initialize the owner trusted keyring\n");
>> -
>> -	owner_trusted_keyring =
>> -	    keyring_alloc(".owner_keyring",
>> -			  KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
>> -			  ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
>> -			   KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
>> -			  KEY_ALLOC_NOT_IN_QUOTA, NULL);
>> -	if (IS_ERR(owner_trusted_keyring))
>> -		panic("Can't allocate owner trusted keyring\n");
>> -
>> -	set_bit(KEY_FLAG_TRUSTED_ONLY, &owner_trusted_keyring->flags);
>> -	return 0;
>> -}
>> -
>> -device_initcall(owner_trusted_keyring_init);
>> -
>> -void load_owner_identified_key(void)
>> -{
>> -	key_ref_t key_ref;
>> -	int ret;
>> -
>> -	if (!owner_keyid)
>> -		return;
>> -
>> -	key_ref = keyring_search(make_key_ref(system_trusted_keyring, 1),
>> -				 &key_type_asymmetric, owner_keyid);
>> -	if (IS_ERR(key_ref)) {
>> -		pr_warn("Request for unknown %s key\n", owner_keyid);
>> -		goto out;
>> -	}
>> -	ret = key_link(owner_trusted_keyring, key_ref_to_ptr(key_ref));
>> -	pr_info("Loaded owner key %s %s\n", owner_keyid,
>> -		ret < 0 ? "failed" : "succeeded");
>> -	key_ref_put(key_ref);
>> -	if (!ret)
>> -		use_owner_trusted_keyring = 1;
>> -out:
>> -	return;
>> -}
>> -
>> -late_initcall(load_owner_identified_key);
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

