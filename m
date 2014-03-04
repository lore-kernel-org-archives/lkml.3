Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaCDOKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:10:18 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:41373 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbaCDOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:10:15 -0500
MIME-Version: 1.0
In-Reply-To: <1393898536.10148.18.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	<43c402f0d4fbcf222f8d669ccf5d237059bd34fe.1393599538.git.d.kasatkin@samsung.com>
	<1393898536.10148.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Tue, 4 Mar 2014 16:10:14 +0200
Message-ID: <CACE9dm_oQnOF1pp0k-GJcN9tOhr6Saod55srTJmsQEfhGphE=g@mail.gmail.com>
Subject: Re: [PATCH 6/8] evm: enable key retention service automatically
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        casey.schaufler@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 4:02 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
>> If keys are not enabled, EVM is not visible in the configuration menu.
>> It may be difficult to figure out what to do unless  you really know.
>>
>> Other subsystems as NFS, CIFS select keys automatically.
>> This patch does the same.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/evm/Kconfig | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
>> index 5aa9103..d35b491 100644
>> --- a/security/integrity/evm/Kconfig
>> +++ b/security/integrity/evm/Kconfig
>> @@ -1,9 +1,10 @@
>>  config EVM
>>       boolean "EVM support"
>> -     depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
>
> Including KEYS is fine, but the trusted-keys dependency is still
> required.  If trusted-keys is enabled, then the TPM and trusted-keys
> must be builtin.
>

Hello.

EVM does not depend on trusted keys, but on encrypted keys.
There is no need for "&& (TRUSTED_KEYS=y || TRUSTED_KEYS=n)"

Header file already provides all necessary compile time dependencies...

-------------------------------------------------------------------------------------------------
#if defined(CONFIG_TRUSTED_KEYS) || \
  (defined(CONFIG_TRUSTED_KEYS_MODULE) && defined(CONFIG_ENCRYPTED_KEYS_MODULE))
extern struct key *request_trusted_key(const char *trusted_desc,
      u8 **master_key, size_t *master_keylen);
#else
static inline struct key *request_trusted_key(const char *trusted_desc,
     u8 **master_key,
     size_t *master_keylen)
{
return ERR_PTR(-EOPNOTSUPP);
}
#endif
-------------------------------------------------------------------------------------------------


- Dmitry

> Mimi
>
>> +     depends on SECURITY
>> +     select KEYS
>> +     select ENCRYPTED_KEYS
>>       select CRYPTO_HMAC
>>       select CRYPTO_SHA1
>> -     select ENCRYPTED_KEYS
>>       default n
>>       help
>>         EVM protects a file's security extended attributes against
>
>



-- 
Thanks,
Dmitry
