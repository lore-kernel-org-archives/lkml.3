Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaC1Q7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:59:01 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51607 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaC1Q67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:58:59 -0400
From: "Ma Haijun" <mahaijuns@gmail.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
        "'Al Viro'" <viro@ZenIV.linux.org.uk>
References: <1395918426-27787-1-git-send-email-mahaijuns@gmail.com> <533540CE.8070703@xs4all.nl>
In-Reply-To: <533540CE.8070703@xs4all.nl>
Subject: RE: [media] videobuf-dma-contig: fix vm_iomap_memory() call
Date: Sat, 29 Mar 2014 00:58:58 +0800
Message-ID: <01a501cf4aa7$08664e30$1932ea90$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQINlLVqLzb/E0QPrytXccCT8QBymwMIUK9kmmHPKwA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> 
> On 03/27/2014 12:07 PM, Ma Haijun wrote:
> > Hi all,
> >
> > This is a trivial fix, but I think the patch itself has problem too.
> > The function requires a phys_addr_t, but we feed it with a dma_handle_t.
> > AFAIK, this implicit conversion does not always work.
> > Can I use virt_to_phys(mem->vaddr) to get the physical address instead?
> > (mem->vaddr and mem->dma_handle are from dma_alloc_coherent)
> 
> Does this actually fail? With what driver and on what hardware?

I notice it when I am reading the code,
so I do not know if any driver is broken.

> 
> I ask because I am very reluctant to make any changes to videobuf. It is
> slowly being replaced by the vastly superior videobuf2 framework. Existing
> drivers in the kernel still using the old videobuf seem to work just fine
> (or at least as fine as videobuf allows you to be).

Sorry that the cover letter is a bit misleading, hope you does not skip the
patch due to this.

The actual problem is that userland virtual address is erroneously passed to
vm_iomap_memory, while it expects physical address.
And that is what the patch try to address.

Seems this bug can be exploited to map and access physical address.
So it is also a security problem, I think we should ether fix it
or remove the code if not used any more.

Regards,

	Haijun


> 
> Regards,
> 
> 	Hans
> 
> >
> > Regards
> >
> > Ma Haijun
> >
> > Ma Haijun (1):
> >   [media] videobuf-dma-contig: fix incorrect argument to
> >     vm_iomap_memory() call
> >
> >  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >

