Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3FDWFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:05:45 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56033 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3FDWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130604215521.GA5819@jshin-Toonie>
References: <20130531150241.GA12006@jshin-Toonie>
	<tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
	<CAE9FiQUJOfcoU8c_Xwhosb1=9=dyaH6mXkERX-zxCUmEXjeNUg@mail.gmail.com>
	<20130604213600.GA5021@jshin-Toonie>
	<20130604215521.GA5819@jshin-Toonie>
Date: Tue, 4 Jun 2013 15:05:41 -0700
X-Google-Sender-Auth: q9v-QruR365Jfrbp38w3-eqIhOQ
Message-ID: <CAE9FiQVqR2KEv5ZWsuL+-guOx6_NEWKMkATfY-Tb8CAV26XMNw@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Fix warnings and errors
 on with CONFIG_MICROCODE=m
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Tue, Jun 04, 2013 at 04:36:00PM -0500, Jacob Shin wrote:
>>
>> It's because the load_ucode_amd_ap() (which is __cpuinit because it
>> can be called during CPU hotplug on).
>
> Sorry, let me clarify. find_ucode_in_initrd() is called by
> load_ucode_amd_ap() during cold boot. However, since
> load_ucode_amd_ap() is also called during suspend/resume (CPU hotplug)
> it has to be __cpuinit. Of course during suspend/resume code path,
> find_ucode_in_initrd() is not called, since it is no longer there in memory.
>
>>
>> Hm.. but yes, I do agree with you, I'm waiting for feedback on this
>> follow up patch to allow multiple concatanated microcode files:
>>
>>   https://lkml.org/lkml/2013/5/31/664
>>
>> I'll submit multi-patch patchset to address your feedback as well.

Those microcode should be with initrd.

During first BP finding and apply it, it is still with initrd that is loaded by
bootloader.

then kernel may move the initrd to mapped range.

then AP will use those moved blob or saved blob during booting path and
hot-add path.

so the find_.._in_initrd should be __init and you just need one pointer
to the blob original or moved.

Thanks

Yinghai
