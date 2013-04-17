Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966029Ab3DQJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:15:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965887Ab3DQJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:15:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
Date: Wed, 17 Apr 2013 11:15:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
In-Reply-To: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304171115.51509.arnd@arndb.de>
X-Provags-ID: V02:K0:m9qc/5vNCmWKOLdXEv22NRLQq7zhWkm78WF+2vbwZpf
 kR+A0q71GuhV0VTtNPuB7Q/66PU+bavEbkVFZ/dfESaMFONFs1
 0KOhxm4L7QrBZDuAuYdzgrDmd1CsKEqIjc5KZp1UPIUyZJvkQj
 4imyNDmkpQen8Sd2OmhZdRMwaZCTdh5YzVEUvFkRxNbRgnHP4f
 0VGft+nRa9GAzNu/Zp4oGM28oWIX2A3dbVsOFkl8MQ2EIdduRh
 NLjXT9Eq3tIrI8CnUr0AByErqszQ/1SrerrE5yEDZfDL6yQHew
 +kh+5vCmAoQU17G1yfhucFtGmLpVOWlCWjdJzg7PucTdol3zTD
 OGBgPhQKIwqJxCck38eo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013, Linus Torvalds wrote:
> Anyway, I'm attaching the untested patch to several drivers. Guys,
> mind taking a look? The point here is to simplify the interface,
> avoiding bugs, but also:
> 
>  5 files changed, 21 insertions(+), 87 deletions(-)
> 
> it needs current -git for the new helper function.
> 
> NOTE! The driver subsystem .mmap functions seem to almost universally do
> 
>     if (io_remap_pfn_range(..))
>         return -EAGAIN;
>     return 0;

I took a look at the hpet_mmap function, which still contains this check:

        if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
                return -EINVAL;

As far as I can tell, this check is implied by the new code in
vm_iomap_memory as the len argument passed here is PAGE_SIZE, so you
can remove another three lines in hpet_mmap.

	Arnd
