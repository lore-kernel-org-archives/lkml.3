Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbbAWMev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:34:51 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:46149 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbbAWMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:34:49 -0500
Message-ID: <54C23FE2.9030303@ahsoftware.de>
Date: Fri, 23 Jan 2015 13:34:42 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de> <54C21F35.1040206@ahsoftware.de> <54C22891.6070506@suse.cz> <54C233FB.3080309@ahsoftware.de> <54C2367C.4000909@ahsoftware.de>
In-Reply-To: <54C2367C.4000909@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 12:54 schrieb Alexander Holler:
> Am 23.01.2015 um 12:43 schrieb Alexander Holler:
>> Am 23.01.2015 um 11:55 schrieb Michal Marek:
>
>>> The .x509 file contains a certificate signed by the private key, but not
>>> the private key. With some scripting, it can be used to verify the
>>> module signatures.
>>
>>
>> Assuming that doesn't change (hopefully), I'll send v2 in a few minutes
>> (it just compiles in order to test it). Thanks for assuring me that
>> .x509 does not and will not contain the private key.
>
> I'm happy I did that. Just deleting the private key currently doesn't
> work. A subsequent make fails:
>
> -----------------------------
> (...)
>    INSTALL arch/x86/crypto/aesni-intel.ko
> Can't read private key
> (...)
> -----------------------------
>
> Maybe that's the reason I've always deleted both files, can't remember.
>
> I will see if I find the time and passion to change the Makefile in
> order to fix that. So you might either use my existing patch or wait if
> I will send a new one.

Having had a look at the Makefile, I don't think I will change that. The 
reasons are:

1. I have no idea about how distro maintainers do handle their private 
and public keys used to sign modules.

2. There might be legitimate reasons to build the kernel using only the 
public key and not regenerating it because the private key doesn't exist.

3. I don't see any real reason not to delete the public key too if this 
new option is enabled. For me it's enough if the kernel is able to 
verify the modules with the embedded public key. For other usage 
scenarios one just should not use the new option.

4. With some scripting it should be possible to extract the public key 
out of an existing binary kernel. So there is no real need to change the 
already complicated build process which might make it even more complicated.

That means I'm still happy with the patch. So feel free to ignore or 
apply it.

Regards,

Alexander Holler
