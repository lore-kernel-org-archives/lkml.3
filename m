Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaHYOEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:04:14 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39677 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaHYOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:04:12 -0400
Date: Mon, 25 Aug 2014 17:04:07 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Dennis Chen <kernel.org.gnu@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        "wanpeng.li" <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH] KVM-Use value reading from MSR when construct the eptp
 in VMX mode
Message-ID: <20140825140407.GH18167@minantech.com>
References: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
 <20140824093759.GG18167@minantech.com>
 <CA+U0gVg13bF_OwRbbH-ZW2Rb9TbYixwgF9m_Utt_cGWb_iH+qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U0gVg13bF_OwRbbH-ZW2Rb9TbYixwgF9m_Utt_cGWb_iH+qQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:16:34AM +0800, Dennis Chen wrote:
> On Sun, Aug 24, 2014 at 5:38 PM, Gleb Natapov <gleb@kernel.org> wrote:
> > On Sun, Aug 24, 2014 at 11:54:32AM +0800, Dennis Chen wrote:
> >> This patch is used to construct the eptp in vmx mode with values
> >> readed from MSR according to the intel x86 software developer's
> >> manual.
> >>
> >>  static u64 construct_eptp(unsigned long root_hpa)
> >>  {
> >> -    u64 eptp;
> >> +    u64 eptp, pwl;
> >> +
> >> +    if (cpu_has_vmx_ept_4levels())
> >> +        pwl = VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
> >> +    else {
> >> +        WARN(1, "Unsupported page-walk length of 4.\n");
> > Page-walk length of 4 is the only one that is supported.
> >
> Since there is a bit 6 in IA32_VMX_EPT_VPID_CAP MSR indicating the
> support for the page-walk length, I think sanity check is necessary.
> But I just checked the code, it's already done in the hardware_setup()
> function which will disable ept feature if the page-wake length is not
> 4. Gleb, any comments for the memory type check part?
Looks fine, but are there CPUs out there that do not support WB for eptp? Since
there was no bug reports about it I assume no.

--
			Gleb.
