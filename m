Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3KHJfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:35:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34409 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KHJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:34:57 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <527CB013.30200@jp.fujitsu.com>
Date: Fri, 8 Nov 2013 18:34:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <matt.fleming@intel.com>, <matthew.garrett@nebula.com>,
        <jlee@suse.com>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at>
In-Reply-To: <527C9B5C.6040509@nod.at>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/08 17:05), Richard Weinberger wrote:
> Am 08.11.2013 08:33, schrieb Yasuaki Ishimatsu:
>> By following works, my system very often fails set_variable() to set new
>> variable to efi variable storage and shows "efivars: set_variable() failed:
>> status=-28" message.
>>
>> - commit 31ff2f20d9003e74991d135f56e503fe776c127c
>>      efi: Distinguish between "remaining space" and actually used space
>> - commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
>>      x86,efi: Implement efi_no_storage_paranoia parameter
>> - commit f8b8404337de4e2466e2e1139ea68b1f8295974f
>>      Modify UEFI anti-bricking code
>>
>> When booting my system, remaining space of efi variable storage is about
>> 5KB. So there is no room that sets a new variable to the storage.
>>
>> According to above works, efi_no_storage_paranoia parameter was prepared
>> for sane UEFI which can do gc and fulfills spec. But why need a system
>> with a sane UEFI set the parameter? It is wrong. A system with a broken
>> UEFI should set the parameter.
> 
> And how does one know that his UEFI is broken?

I have no idea. But at least, bricked board is broken UEFI.
Do you know the issue occurs on several boards or specific board?

Thanks,
Yasuaki Ishimatsu

> "Oh my board is briked because I wrote too much into a variable, maybe setting
> efi_storage_paranoia would have saved me. Let's try with the next board..." ;)
> 
> Thanks,
> //richard
> 


