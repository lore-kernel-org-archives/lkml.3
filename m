Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaHZCel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:34:41 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52887 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaHZCej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:34:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140825140407.GH18167@minantech.com>
References: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
 <20140824093759.GG18167@minantech.com> <CA+U0gVg13bF_OwRbbH-ZW2Rb9TbYixwgF9m_Utt_cGWb_iH+qQ@mail.gmail.com>
 <20140825140407.GH18167@minantech.com>
From: Dennis Chen <kernel.org.gnu@gmail.com>
Date: Tue, 26 Aug 2014 10:34:18 +0800
Message-ID: <CA+U0gVh_dWztJ4CQzbNTUKFmew75RE4kc=qrikdFm6hs3S2J0Q@mail.gmail.com>
Subject: Re: [PATCH] KVM-Use value reading from MSR when construct the eptp in
 VMX mode
To: Gleb Natapov <gleb@kernel.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, "wanpeng.li" <wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:04 PM, Gleb Natapov <gleb@kernel.org> wrote:
> On Mon, Aug 25, 2014 at 11:16:34AM +0800, Dennis Chen wrote:
>> On Sun, Aug 24, 2014 at 5:38 PM, Gleb Natapov <gleb@kernel.org> wrote:
>> > On Sun, Aug 24, 2014 at 11:54:32AM +0800, Dennis Chen wrote:
>> >> This patch is used to construct the eptp in vmx mode with values
>> >> readed from MSR according to the intel x86 software developer's
>> >> manual.
>> >>
>> >>  static u64 construct_eptp(unsigned long root_hpa)
>> >>  {
>> >> -    u64 eptp;
>> >> +    u64 eptp, pwl;
>> >> +
>> >> +    if (cpu_has_vmx_ept_4levels())
>> >> +        pwl = VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
>> >> +    else {
>> >> +        WARN(1, "Unsupported page-walk length of 4.\n");
>> > Page-walk length of 4 is the only one that is supported.
>> >
>> Since there is a bit 6 in IA32_VMX_EPT_VPID_CAP MSR indicating the
>> support for the page-walk length, I think sanity check is necessary.
>> But I just checked the code, it's already done in the hardware_setup()
>> function which will disable ept feature if the page-wake length is not
>> 4. Gleb, any comments for the memory type check part?
> Looks fine, but are there CPUs out there that do not support WB for eptp? Since
> there was no bug reports about it I assume no.

Hmm, currently I can't find a x86 processor that don't support WB for
eptp, also there is no relevant bug reported.
I just read the intel SDM 24.6.11: SW should read the VMX capability
MSR_IA32_VMX_EPT_VPID_CAP to determine
what EPT MT are supported. But looks like this is not a big concern in
the community, so let's go back this thread if
we encounter one unfornately in the future. Thanks for the comments.

>
> --
>                         Gleb.



-- 
Den
