Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaJUUFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:05:36 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:50844 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaJUUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6978-uGD6Mq+tESXVZsmZSLWCuAwyBzO9pKHg_foNZPg@mail.gmail.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170617.4063.2807.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo45JNAFM7gYM39hsAw=O+Pe2FLJYpj3WV0p2rDe-_t+xg@mail.gmail.com> <CAErSpo6978-uGD6Mq+tESXVZsmZSLWCuAwyBzO9pKHg_foNZPg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 21 Oct 2014 14:05:10 -0600
Message-ID: <CAErSpo7D_vHMebzhTfGKyyX=dtg+H0GiJV3fw2VaMTfdkDfa8g@mail.gmail.com>
Subject: Re: [PATCH v1 05/10] MIPS: MT: Move "weak" from vpe_run() declaration
 to definition
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 7:49 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Stephen]
>
> On Wed, Oct 15, 2014 at 5:28 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc linux-mips]
>>
>> On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> When the "weak" attribute is on a declaration in a header file, every
>>> definition where the header is included becomes weak, and the linker
>>> chooses one definition based on link order (see 10629d711ed7 ("PCI: Remove
>>> __weak annotation from pcibios_get_phb_of_node decl")).
>>>
>>> Move the "weak" attribute from the declaration to the default definition so
>>> we always prefer a non-weak definition over the weak one, independent of
>>> link order.
>>>
>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>> CC: linux-mips@linux-mips.org

Dropping this permanently since I haven't heard from any MIPS folks.

>>> ---
>>>  arch/mips/include/asm/vpe.h |    2 +-
>>>  arch/mips/kernel/vpe-mt.c   |    2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
>>> index 7849f3978fea..80e70dbd1f64 100644
>>> --- a/arch/mips/include/asm/vpe.h
>>> +++ b/arch/mips/include/asm/vpe.h
>>> @@ -122,7 +122,7 @@ void release_vpe(struct vpe *v);
>>>  void *alloc_progmem(unsigned long len);
>>>  void release_progmem(void *ptr);
>>>
>>> -int __weak vpe_run(struct vpe *v);
>>> +int vpe_run(struct vpe *v);
>>>  void cleanup_tc(struct tc *tc);
>>>
>>>  int __init vpe_module_init(void);
>>> diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
>>> index 2e003b11a098..0e5899a2cd96 100644
>>> --- a/arch/mips/kernel/vpe-mt.c
>>> +++ b/arch/mips/kernel/vpe-mt.c
>>> @@ -23,7 +23,7 @@ static int major;
>>>  static int hw_tcs, hw_vpes;
>>>
>>>  /* We are prepared so configure and start the VPE... */
>>> -int vpe_run(struct vpe *v)
>>> +int __weak vpe_run(struct vpe *v)
>>>  {
>>>         unsigned long flags, val, dmt_flag;
>>>         struct vpe_notifications *notifier;
>>>
>
> Just FYI, this patch was in linux-next today, but I dropped it
> temporarily because Fengguang's auto-builder found the following issue
> with it:
>
> All error/warnings:
>
>    arch/mips/kernel/vpe.c: In function 'vpe_release':
>>> arch/mips/kernel/vpe.c:830:29: error: the address of 'vpe_run' will always evaluate as 'true' [-Werror=address]
>       if ((vpe_elfload(v) >= 0) && vpe_run) {
>                                 ^
>    cc1: all warnings being treated as errors
