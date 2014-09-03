Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaICNpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:45:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30133 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbaICNps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:45:48 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-21-54071b88c20a
Message-id: <54071AD6.4080001@samsung.com>
Date: Wed, 03 Sep 2014 16:42:46 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH v2 2/3] integrity: move integrity subsystem options to a
 separate menu
References: <cover.1409728926.git.d.kasatkin@samsung.com>
 <bce4893d9928b4c6ba9e69e8b4d858489acf6e9e.1409728926.git.d.kasatkin@samsung.com>
 <1409747724.21827.48.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1409747724.21827.48.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xa7od0uwhBhMbDC2+LK2zeDljHrvF
	5V1z2Cw+9Dxis/i0YhKzA6vHzll32T0eHNrM4rF7wWcmj8+b5AJYorhsUlJzMstSi/TtErgy
	Jjb2MhbMkq3oPv6OrYFxt3gXIyeHhICJxKot/xghbDGJC/fWs3UxcnEICSxllOjceYYZwmlk
	kvg6eRMrhDOLUeLKlb8sIC28AloSn598YgKxWQRUJU6t2sgOYrMJ6ElsaP4BZosKhEk8+3WQ
	CaJeUOLH5HtgvSICmhLHWj8yggxlFuhllOhf1we0joNDWCBG4upOb4hlpxgl2jdMYwZp4BTw
	kOibPZMNpIZZQF1iypRckDCzgLzE5jVvwUqEgG7oXruWDeIdRYnTk88xT2AUnoVk9SyE7llI
	uhcwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImHLzsYFx+zOsQowMGoxMNboMYWIsSa
	WFZcmXuIUYKDWUmEV5OZPUSINyWxsiq1KD++qDQntfgQIxMHp1QDI4PMp7rrTILLVz/b36wg
	8Pj/v6gT2a1zWU0DMj8stTvGlPZhVd/nkC+5HfxTS9lm60j+CVRpkYisDj/9I6ywothI3n7N
	LV2lq+kL43ivrvc6v+Hck6dGVmV/70z48b2o42asg/fsuf3ysr/enMh3PiZV9O0Kh+mD+8lb
	iosuTo0ofBHAdHfpVSWW4oxEQy3mouJEAGaS3KplAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:35, Mimi Zohar wrote:
> On Wed, 2014-09-03 at 10:29 +0300, Dmitry Kasatkin wrote: 
>> Integrity subsystem got lots of options and takes more than half
>> of security menu.
>>
>> This patch moves integrity subsystem options to a separate menu.
>> It does not affect existing configuration. Re-configuration is
>> not needed.
>>
>> Changes in v2:
>> - previous patch moved integrity out of the 'security' menu.
>>   This version keeps integrity as a security option (Mimi).
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/Kconfig     | 14 ++++++++++++--
>>  security/integrity/evm/Kconfig |  9 +--------
>>  security/integrity/ima/Kconfig |  3 +--
>>  3 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
>> index f79d853..a734a83 100644
>> --- a/security/integrity/Kconfig
>> +++ b/security/integrity/Kconfig
>> @@ -1,7 +1,13 @@
>>  #
>>  config INTEGRITY
>> -	def_bool y
>> -	depends on IMA || EVM
>> +	bool "Integrity subsystem support"
>> +	depends on SECURITY
>> +	default y
>> +
>> +if INTEGRITY
>> +
>> +menu "Options"
>> +
> Instead of moving everything to a separate menu, I would leave the
> ability to enable/disable IMA and EVM on the security page, but move
> their options to separate pages.  So unless someone wants to change the
> default options, they're hidden.
>
> There are Kconfig examples for enabling the option in the parent
> directory and clicking on the option brings up a separate menu (eg. NET,
> WIRELESS).

Actually it is better to have as separate menu, because there are
integrity level specific options there as auditing or digital
signatures. It is nice to have them all in one place.

>>  config INTEGRITY_SIGNATURE
>>  	boolean "Digital signature verification using multiple keyrings"
>> @@ -46,3 +52,7 @@ config INTEGRITY_AUDIT
>>
>>  source security/integrity/ima/Kconfig
>>  source security/integrity/evm/Kconfig
>> +
>> +endmenu
>> +
>> +endif   # if INTEGRITY
>> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
>> index d606f3d..df20a2f 100644
>> --- a/security/integrity/evm/Kconfig
>> +++ b/security/integrity/evm/Kconfig
>> @@ -1,6 +1,6 @@
>>  config EVM
>>  	boolean "EVM support"
>> -	depends on SECURITY
>> +	depends on INTEGRITY
> By adding the "if INTEGRITY",  the "depends on INTEGRITY" is redundant.
> Please remove the depends here and in the other places.

Will do.

- Dmitry
> Mimi
>
>>  	select KEYS
>>  	select ENCRYPTED_KEYS
>>  	select CRYPTO_HMAC
>> @@ -12,10 +12,6 @@ config EVM
>>
>>  	  If you are unsure how to answer this question, answer N.
>>
>> -if EVM
>> -
>> -menu "EVM options"
>> -
>>  config EVM_ATTR_FSUUID
>>  	bool "FSUUID (version 2)"
>>  	default y
>> @@ -47,6 +43,3 @@ config EVM_EXTRA_SMACK_XATTRS
>>  	  additional info to the calculation, requires existing EVM
>>  	  labeled file systems to be relabeled.
>>
>> -endmenu
>> -
>> -endif
>> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
>> index 08758fb..2477d1e 100644
>> --- a/security/integrity/ima/Kconfig
>> +++ b/security/integrity/ima/Kconfig
>> @@ -2,8 +2,7 @@
>>  #
>>  config IMA
>>  	bool "Integrity Measurement Architecture(IMA)"
>> -	depends on SECURITY
>> -	select INTEGRITY
>> +	depends on INTEGRITY
>>  	select SECURITYFS
>>  	select CRYPTO
>>  	select CRYPTO_HMAC
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

