Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3KTG1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 01:27:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51352 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTG1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 01:27:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528C562B.3070008@jp.fujitsu.com>
Date: Wed, 20 Nov 2013 15:26:51 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Madper Xie <cxie@redhat.com>
CC: Matt Fleming <matt@console-pimps.org>, Richard Weinberger <richard@nod.at>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <matt.fleming@intel.com>, <matthew.garrett@nebula.com>,
        <jlee@suse.com>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at> <527CBDD3.2020609@jp.fujitsu.com> <20131108143421.GB22636@console-pimps.org> <52809AEB.9080100@jp.fujitsu.com> <20131111105424.GD22636@console-pimps.org> <528AD50D.6060503@jp.fujitsu.com> <87siutqdwv.fsf@redhat.com>
In-Reply-To: <87siutqdwv.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/19 12:16), Madper Xie wrote:
> 
> isimatu.yasuaki@jp.fujitsu.com writes:
> 
>> Hi Matt,
>>
>> Sorry for late the reply.
>>
>>
>> (2013/11/11 19:54), Matt Fleming wrote:
>>> On Mon, 11 Nov, at 05:52:59PM, Yasuaki Ishimatsu wrote:
>>>> Hi Matt,
>>>>
>>>> I uses FUJITSU's x86 box.
>>>> This does not become bricked even if I use all efi variable storage.
>>>> Thus I want a way to not need to specify efi_no_storage_paranoia
>>>> parameter.
>>>
>>> The efi_no_storage_paranoia parameter was introduced because some
>>> machines do not initiate garbage collection of the NVRAM until you
>>> allocate all space - basically it's a switch to turn off the "save 5KB
>>> of stoarge at all times" workaround that is needed to avoid bricking
>>> some machines.
>>>
>>> The intention of the switch is not to allow you to fill your NVRAM just
>>> because you can. If that is something you want to do then I think it's
>>> fair to require you to explicitly turn on efi_no_storage_paranoia. But
>>> I'm assuming here that you are doing something like writing lots and
>>> lots of pstore entries and just want to write as many as your variable
>>> storage will allow? Or are you doing something more fundamental like
>>> creating BootXXXX entries?
>>>
>>> What are you doing to run into the 5KB reserve? How much NVRAM does your
>>> machine come with?
>>
>> I just add boot entry to NVRAM by efibootmgr command. But when Linux boots up,
>> the remaining NVRAM is less than 5Kbyte. So I cannnot add new entry.
>>
> Howdy Yasuaki,
>    If the remaining NVRAM is less than 5Kb, your writing will trigger a
>    NVRAM storage reclamation. However you still failed creating entry. So
>    I'm just curious what itmes occupy lots of nvram storage space.

Even if we got EFI_OUT_OF_RESOURCES while running Linux, gc does not run.
Trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS environment with
UEFI. So on my system, if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte threshold,
we cannot use nvram storage until EFI_OUT_OF_RESOURCES occurs on pre OS
environment with UEFI.

Thanks,
Yasuaki Ishimatsu

> 
>> Thanks,
>> Yasuaki Ishimatsu
> 
> --
> Best,
> Madper
> 


