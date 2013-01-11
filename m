Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3AKQgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:36:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab3AKQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:36:34 -0500
Date: Fri, 11 Jan 2013 11:35:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130111163548.GB25620@phenom.dumpdata.com>
References: <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
 <20130109004340.GA12234@konrad-lan.dumpdata.com>
 <87txqruq8p.fsf@xmission.com>
 <CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
 <CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
 <20130109132409.GB18395@phenom.dumpdata.com>
 <CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
 <87d2xeul5v.fsf@xmission.com>
 <CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
 <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 03:07:10PM -0800, Yinghai Lu wrote:
> On Wed, Jan 9, 2013 at 1:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Wed, Jan 9, 2013 at 1:00 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Yinghai Lu <yinghai@kernel.org> writes:
> >>
> >>> please check updated attached. It should address all your request.
> >>
> >> There is one significant bug that I can see.
> >>
> >> swiotlb_print_info tests no_iotlb_memory but no_iotlb_memory is set
> >> after swiotlb_init_with_tlb returns.
> >
> > there is another swiotlb_print_info calling from
> > pci_swiotlb_late_init
> >
> > void __init pci_swiotlb_late_init(void)
> > {
> >         /* An IOMMU turned us off. */
> >         if (!swiotlb)
> >                 swiotlb_free();
> >         else {
> >                 printk(KERN_INFO "PCI-DMA: "
> >                        "Using software bounce buffering for IO (SWIOTLB)\n");
> >                 swiotlb_print_info();
> >         }
> > }
> >
> > so we need that checking when swiotlb == 1, but actually we can not
> > allocate that before.
> 
> Eric, so the code is right to put checking in swiotlb_print_info ?
> 
> I'd like to post the whole patchset again and ask HPA to put them in tip/next
> to catch -v3.9 merging window.

I'm the frontline maintainer of swiotlb and related stuff so if you want to follow
the proper protocol you should wait until I give you my Ack.

I need to check this patch out and then also test-run them on IA64, AMD-VI, Calgary-X
GART and Intel VT-d to make a sanity test.

However, this particular patch can go outside the mega-patchset you have. So you
could post the mega-patchset to hpa without this being in it and just mention
that there is this extra one that Konrad is handling.
