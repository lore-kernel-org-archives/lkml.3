Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3GMWdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 18:33:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53646 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab3GMWdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 18:33:37 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQVrq3_oeFFLVhXvfBM75frQghzy7i6r+N4gW_F-K0-n8g@mail.gmail.com>
References: <1373659660-31123-1-git-send-email-keescook@chromium.org> <20130712203802.GA14702@www.outflux.net> <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com> <51E169F1.5010301@zytor.com> <CAE9FiQVrq3_oeFFLVhXvfBM75frQghzy7i6r+N4gW_F-K0-n8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 13 Jul 2013 15:33:09 -0700
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Message-ID: <f8b2c6f6-6f00-4966-9d95-56d7ef3eb626@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we will need to map the uart explicitly, which is complex as that in turn implies seeing up something like the fixmap for the decompressor... not impossible but additional complexity to be sure.  At least on 64 bits the high half should not conflict with any physical addresses.

Either that or be able to add pagetables to map the mmio directly or via a #PF handler like we already have in the early kernel.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Sat, Jul 13, 2013 at 7:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/12/2013 11:47 PM, Yinghai Lu wrote:
>>>
>>> for 32 bit, that is ok.
>>> for 64 bit via 32bit bootloader, arch/x86/boot/compressed/head_64.S
>>> will set page table for first 4G still ok.
>>> for 64 bit via 64bit loader, like kexec via bzImage64, First
>Kernel/Kexec only
>>> set ident mapping for usable range, so mmio just under 64 is not
>mapped.
>>>
>>> Looks like we need to update boot.txt to add requirement for 64bit
>bootloader
>>> that 0-4G need to be all ident mapping?
>>>
>>
>> I think that is an unrealistic requirement, especially if this is the
>> sole user.
>
>That will cause regression for:
>64bit system with kexec/kdump bzImage64.
>if second kernel carry "console=uart,mmio,0xABCD0000"
>
>or we can extend kexec-tools to make it scan second kernel command line
>string
>and one entry into image->segment[]
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
