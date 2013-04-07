Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab3DGJoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095Ab3DGJoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:44:12 -0400
Date: Sun, 7 Apr 2013 11:43:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] kvm: add PV MMIO EVENTFD
Message-ID: <20130407084301.GC10317@redhat.com>
References: <20130404120825.GD17919@redhat.com>
 <959E147D-EB7B-4F4B-9F84-4F1BBA98DEF8@suse.de>
 <20130404123806.GG17919@redhat.com>
 <EF153515-9835-4FB9-B6BC-73D0BDC86492@suse.de>
 <20130404124501.GH17919@redhat.com>
 <1B68D701-103D-4B1A-8F5E-3916753699CB@suse.de>
 <20130404125649.GI17919@redhat.com>
 <8E65D34D-2DA7-4C2E-9C3E-BE3A7DBC3279@suse.de>
 <20130404131457.GJ17919@redhat.com>
 <20130407093038.GL17919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130407093038.GL17919@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 12:30:38PM +0300, Gleb Natapov wrote:
> On Thu, Apr 04, 2013 at 04:14:57PM +0300, Gleb Natapov wrote:
> > > > 
> > > >>> is to move to MMIO only when PIO address space is exhausted. For PCI it
> > > >>> will be never, for PCI-e it will be after ~16 devices.
> > > >> 
> > > >> Ok, let's go back a step here. Are you actually able to measure any speed in performance with this patch applied and without when going through MMIO kicks?
> > > >> 
> > > >> 
> > > > That's the question for MST. I think he did only micro benchmarks till
> > > > now and he already posted his result here:
> > > > 
> > > > mmio-wildcard-eventfd:pci-mem 3529
> > > > mmio-pv-eventfd:pci-mem 1878
> > > > portio-wildcard-eventfd:pci-io 1846
> > > > 
> > > > So the patch speedup mmio by almost 100% and it is almost the same as PIO.
> > > 
> > > Those numbers don't align at all with what I measured.
> > I am trying to run vmexit test on AMD now, but something does not work
> > there. Next week I'll fix it and see how AMD differs, bit on Intel those are the
> > numbers.
> > 
> The numbers are:
> vmcall 1921
> inl_from_kernel 4227
> outl_to_kernel 2345
> 
> outl is specifically optimized to not go through the emulator since it
> is used for virtio kick. mmio-pv-eventfd is the same kind of
> optimization but for mmio.
>  
> --
> 			Gleb.


Hmm so on AMD it's more like 20% overhead, like ARM.

-- 
MST
