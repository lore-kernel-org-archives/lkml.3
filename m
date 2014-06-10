Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaFJM7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:59:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52651 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaFJM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:59:19 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c0-53970124f65f
Message-id: <5397010E.2080903@samsung.com>
Date: Tue, 10 Jun 2014 15:58:54 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
Cc: zohar@linux.vnet.ibm.com, dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
In-reply-to: <20140610122008.GA31944@hansolo.jdub.homelinux.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xq7oqjNODDT40aFm8a/rNYvFlaZ3F
	gXdPWCxm73rIYnF51xw2iw89j9gsrj6czWLxacUkZgcOj52z7rJ7TDuxjMXjwaHNLB7v911l
	81h34yu7x+dNcgFsUVw2Kak5mWWpRfp2CVwZ+26cZSl4Kl+x4t0ztgbGCZJdjJwcEgImEnMf
	L2WFsMUkLtxbz9bFyMUhJLCUUWLDwx4WCKeRSWLBhpnMEM4sRom/Z96zgbTwCmhJXFq6ih3E
	ZhFQldj2aDITiM0moCexofkHUJyDQ1QgQuLxBSGIckGJH5PvsYDYIgLKEmuvbgfbxixwiFHi
	+dNWZpCEsECIxLFv89khlq1hlNjV9gRsAaeAg8STE11gNrOAjsT+1mlsELa8xOY1b8GahYCO
	6F67lg3iH0WJ05PPMU9gFJ6FZPksJO2zkLQvYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7
	iRESRV92MC4+ZnWIUYCDUYmHl0NnWrAQa2JZcWUu0PkczEoivG1/gUK8KYmVValF+fFFpTmp
	xYcYmTg4pRoYzRn5J/RL5OyQZC642XjrciqTg4njAdYF+aJT/lv+v/Anvlnkj9Pah6fV6oR5
	njkc3b9WuWpZgYeRqnnoXU0jQalrJz9Xd5s3/WV1LG05e2QF2zWBaUKlT313Ra9f/qCruOdy
	3qe+pONTb6VMFgrVU7TV9/ucHmN55kD8/X/H/MyvLpn0JNtfiaU4I9FQi7moOBEA+tejkIAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 15:20, Josh Boyer wrote:
> On Tue, Jun 10, 2014 at 11:48:14AM +0300, Dmitry Kasatkin wrote:
>> Hi Mimi,
>>
>> As you asked ofline , here is possible equivalent and simpler alternative
>> patches not requiring to have additional keyring.
>>
>> First patch are irrelevant minor fixes.
>>
>> Also I want to discuss here Fedora UEFI patches as they are the reason for
>> the these original patchset.
>>
>> http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
>>
>> They provide functionality to specify MokIgnoreDb variable to limit loading of
>> UEFI keys only from MOK List, while ignoring DB. This is certainly a good
>> functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
>> to prevent loading keys from UEFI at all. And this might not be a good default
>> functionality. Someone might want not allow loading of keys from UEFI unless
>> kernel parameter is specified to allow it without recompiling the kernel
>> and disabling MODULE_SIG_UEFI.
>>
>> Josh, why such design decision was made?
> IIRC, it's because kernel parameters can be added programmatically from a
> remote user if they gain root access.  Having a kernel parameter to
> disable a key piece of secure boot isn't all that great.  We disable
> other kernel parameters like acpi_rspd as well.

I see the point, as we have unprotected boot loader configuration.

>> Why not to provide kernel parameter to have more fine-tune control over the
>> functionality? Unconfigured machines will not have MokIgnoreDb and will
>> allow to load kernel modules signed with certain undesired keys. In fact,
> Undesired by whom?  If SB is enabled, your machine's firmware already
> trusts those keys.

It is tricky issue. But yes and no... If I forced to trust MS key to run
SHIM, it does not mean
that I want to trust MS key to run kernel and load modules or use MS key
to valid other keys on system keyring.

Personally I took ownership of my laptop laptop by enrolling my key.
I also re-signed SHIM...

But for convenience I keep MS key to boot from any USB stick, though
booting is password protected...

-> So the only point I trust MS key is when I type my password to boot...

And next when system is running, I do not want MS or Lenovo key would be
used to verify kernel modules or signed files...



>> I beleive, it should be default behavior of the kernel. Bootloader can
>> enable UEFI functionality by specifing it on the kernel command line.
> If it was enabled via boot params, or done in the early setup code that
> might be possible.  I don't think a kernel parameter is the right
> solution though.  I've added Matthew on CC.

Thanks for reply.

> josh
>
>> Second patch allows to overcome keys coming from UEFI for key validation by
>> specifing owner key id and is an alternative for v5 4/4 patch.
>>
>> It was also a good idea presented in Mimi's v4 4/4 patch to have possibility
>> to limit key trust valiation by only builtin keys. Third patch as an alternative.
>> It uses keys->flags to specify origin of the key, but any additional field could
>> be added as well.
>>
>> Both key id and origin verification is done in x509_validate_trust().
>>
>> Thanks,
>> Dmitry
>>
>> Dmitry Kasatkin (3):
>>   KEYS: fix couple of things
>>   KEYS: validate key trust only with selected owner key
>>   KEYS: validate key trust only with builtin keys
>>
>> Mimi Zohar (1):
>>   KEYS: define an owner trusted keyring
>>
>>  Documentation/kernel-parameters.txt      |  5 +++++
>>  crypto/asymmetric_keys/x509_public_key.c | 35 +++++++++++++++++++++++++++++---
>>  include/linux/key.h                      |  1 +
>>  kernel/system_keyring.c                  |  1 +
>>  4 files changed, 39 insertions(+), 3 deletions(-)
>>
>> -- 
>> 1.9.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

