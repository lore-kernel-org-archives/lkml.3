Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3A2CMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:12:52 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:50627 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3A2CMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:12:50 -0500
Date: Tue, 29 Jan 2013 11:12:35 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-Id: <20130129111235.23466333.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <1359387416.11144.177.camel@bling.home>
References: <20130124220027.11061.76400.stgit@bling.home>
	<20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<5101FBE8.9000206@linux.vnet.ibm.com>
	<20130128105903.GA22871@redhat.com>
	<20130128212543.274a94d8021cfdabc3efc0e1@gmail.com>
	<1359387416.11144.177.camel@bling.home>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013 08:36:56 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 2013-01-28 at 21:25 +0900, Takuya Yoshikawa wrote:
> > On Mon, 28 Jan 2013 12:59:03 +0200
> > Gleb Natapov <gleb@redhat.com> wrote:
> > 
> > > > It sets spte based on the old value that means the readonly flag check
> > > > is missed. We need to call kvm_arch_flush_shadow_all under this case.
> > > Why not just disallow changing memory region KVM_MEM_READONLY flag
> > > without deleting the region?
> > 
> > Sounds good.
> > 
> > If you prefer, I can fold the required change into my patch.
> 
> That would seem to make my patch 1/2 unnecessary.  Thanks,

I've decided not to fold that change into my
  KVM: set_memory_region: Identify the requested change explicitly
since this is a functional change, see v3 I posted today.

Since QEMU is not the only hypervisor using KVM, we should make the
change with a proper subject informing every user of the new restriction.

If the maintainers prefer to remove Alex's patch 1/2 first and then
rebase my v3 patch, I can do so.

	Takuya
