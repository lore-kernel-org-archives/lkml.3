Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3IVP2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 11:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33766 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab3IVP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 11:28:13 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130922133722.GC28718@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de> <1379602494-26684-12-git-send-email-bp@alien8.de> <20130921113929.GB1587@pd.tnic> <20130922123515.GA7476@dhcp-16-126.nay.redhat.com> <20130922133722.GC28718@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 22 Sep 2013 08:27:34 -0700
To: Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Message-ID: <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address that faults is interesting in that it is indeed just below -4G.  The question at hand is probably what information you are using to build the EFI mappings in the secondary kernel and what could make it not match the primary.

Assuming it isn't as simple as the mappings never get built at all.


Borislav Petkov <bp@alien8.de> wrote:
>On Sun, Sep 22, 2013 at 08:35:15PM +0800, Dave Young wrote:
>> I tested your new patch, it works both with efi stub and grub boot in
>> 1st kernel.
>
>Good, thanks!
>
>> But it paniced in kexec boot with my kexec related patcheset, the
>patchset
>
>That's the second kernel, right?
>
>> contains 3 patch:
>> 1. introduce cmdline kexecboot=<0|1|2>; 1 == kexec, 2 == kdump
>> 2. export physical addr fw_vendor, runtime, tables to
>/sys/firmware/efi/systab
>> 3. if kexecboot != 0, use fw_vendor, runtime, tables from bootparams;
>Also do not
>>    call SetVirtualAddressMao in case kexecboot.
>> 
>> The panic happens at the last line of efi_init:
>>         /* clean DUMMY object */
>>         efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
>>                          EFI_VARIABLE_NON_VOLATILE |
>>                          EFI_VARIABLE_BOOTSERVICE_ACCESS |
>>                          EFI_VARIABLE_RUNTIME_ACCESS,
>>                          0, NULL);
>> 
>> Below is the dmesg:
>> [    0.003359] pid_max: default: 32768 minimum: 301
>> [    0.004792] BUG: unable to handle kernel paging request at
>fffffffefde97e70
>> [    0.006666] IP: [<ffffffff8103a1db>]
>virt_efi_set_variable+0x40/0x54
>> [    0.006666] PGD 36981067 PUD 35828063 PMD 0
>
>Here it is - fffffffefde97e70 is not mapped in the pagetable, PMD is 0.
>
>Ok, can you upload your patches somewhere and tell me exactly how to
>reproduce this so that I can take a look too?
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
