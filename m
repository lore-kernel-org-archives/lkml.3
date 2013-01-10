Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3AJXHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:07:14 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:46376 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3AJXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
References: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
	<CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
	<CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
	<20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
	<CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
Date: Thu, 10 Jan 2013 15:07:10 -0800
X-Google-Sender-Auth: HF3SOz5ozaa2_FRP1KfLOt0eHyg
Message-ID: <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Jan 9, 2013 at 1:00 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> please check updated attached. It should address all your request.
>>
>> There is one significant bug that I can see.
>>
>> swiotlb_print_info tests no_iotlb_memory but no_iotlb_memory is set
>> after swiotlb_init_with_tlb returns.
>
> there is another swiotlb_print_info calling from
> pci_swiotlb_late_init
>
> void __init pci_swiotlb_late_init(void)
> {
>         /* An IOMMU turned us off. */
>         if (!swiotlb)
>                 swiotlb_free();
>         else {
>                 printk(KERN_INFO "PCI-DMA: "
>                        "Using software bounce buffering for IO (SWIOTLB)\n");
>                 swiotlb_print_info();
>         }
> }
>
> so we need that checking when swiotlb == 1, but actually we can not
> allocate that before.

Eric, so the code is right to put checking in swiotlb_print_info ?

I'd like to post the whole patchset again and ask HPA to put them in tip/next
to catch -v3.9 merging window.

Thanks

Yinghai
