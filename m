Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3KZB4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:56:55 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49011 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3KZB4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:56:53 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Thread-Topic: /proc/vmcore mmap() failure issue
Thread-Index: AQHO6ex5OH+FUn+AQk6XAdmX3CDO8Jo2rWvA
Date: Tue, 26 Nov 2013 01:51:47 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C5FAC@BPXM01GP.gisp.nec.co.jp>
References: <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <20131118135511.GA30637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
 <20131120145901.GB27924@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C43E3@BPXM01GP.gisp.nec.co.jp>
 <528DC4F2.5040000@jp.fujitsu.com> <20131121165237.GG16208@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C5AB3@BPXM01GP.gisp.nec.co.jp>
 <529311F1.90603@jp.fujitsu.com> <20131125144150.GC21378@redhat.com>
In-Reply-To: <20131125144150.GC21378@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/25 23:42:31, kexec <kexec-bounces@lists.infradead.org> wrote:
> On Mon, Nov 25, 2013 at 06:01:37PM +0900, HATAYAMA Daisuke wrote:
> 
> [..]
> > > I agree to avoid this issue by fixing makedumpfile as workaround while to
> > > fix kernel is so tough and risky. However, it sounds strange to me to fix
> > > userspace side elaborately for such definite kernel issue whose cause is
> > > known, so we should fix the kernel itself.
> > > 
> > 
> > > Otherwise, will you continue to add specific fixes into user tools to
> > > address kernel issues like this case ?
> > > 
> > 
> > makedumpfile supports a wide range of kernel versions and needs to satisfy
> > backward compatibility. mmap() on /proc/vmcore might be backported to some of
> > the old versions on some distributions if necessary. Then, it's hard to fix
> > each old kernel at each back port. The method that can be applied to all the
> > kernels in general, is necessary.
> > 
> > Also, looking at ia64 case where there's boot loader data on partial pages,
> > there could be other environments where partial pages contain other important
> > data other components have. So, the issue depends not only on kernels but also
> > other components such as boot loader and firmwares that can put data on
> > partial pages. We need to get there as long as there's important data there
> > and we have access to there.
> 
> Hi Atsushi, Hatayama,
> 
> So even if we fix the mmap() issue in kernel, looks like it will be a
> good idea to ship the fix in makedumpfile as there have been a kernel
> release where mmap() will cause issues.

OK, I'll make a patch set for makedumpfile to address issues about mmap():

  1. Fix the partial page issue
  2. Introduce general fall back structure (I already posted)
     http://lists.infradead.org/pipermail/kexec/2013-November/010199.html
  3. Add --non-mmap option


Thanks
Atsushi Kumagai

> Having said that, I think we need to fix it in kernel also. I was not sure
> that what's the right fix. Should we truncate partial pages or should
> we just copy partial pages from old memory to new kernel's memory and fill
> partial page with zeros. And that's why I was hoping that makedumpfile
> can fill the gap.
> 
> Copying partial pages to new memory seems like a safer approach. So may
> be we can take a fix in makeudmpfile and another in kernel.
> 
> Hatayama, I know that in the past your initial mmap() patches were copying
> partial pages to new kernel's memory. Would you like to resurrect that
> patch again?
> 
> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
