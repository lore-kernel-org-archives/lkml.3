Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJPHXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:23:22 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50928 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaJPHXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:23:20 -0400
Date: Thu, 16 Oct 2014 09:23:07 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Nathan Fontenot <nfont@austin.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v1 09/10] memory-hotplug: Remove "weak" from
 memory_block_size_bytes() declaration
Message-ID: <20141016092307.4a5981f7@mschwide>
In-Reply-To: <CAErSpo4fS1fdNvur13LZVYomWdmjZnYO49Gc9BJv_BRxAXX3GA@mail.gmail.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<20141015170644.4063.6843.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<CAErSpo4fS1fdNvur13LZVYomWdmjZnYO49Gc9BJv_BRxAXX3GA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101607-0013-0000-0000-000001782E1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 17:38:02 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> [+cc Rashika, Nathan, Anton, Blanchard, Heiko, Yinghai, Martin,
> linux-s390; sorry, I botched my "stg mail" so you weren't included the
> first time.  s390 and x86 define their own memory_block_size_bytes()
> and are at risk for this problem.]
> 
> On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > drivers/base/memory.c provides a default memory_block_size_bytes()
> > definition explicitly marked "weak".  Several architectures provide their
> > own definitions intended to override the default, but the "weak" attribute
> > on the declaration applied to the arch definitions as well, so the linker
> > chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
> > annotation from pcibios_get_phb_of_node decl")).
> >
> > Remove the "weak" attribute from the declaration so we always prefer a
> > non-weak definition over the weak one, independent of link order.
> >
> > Fixes: 41f107266b19 ("drivers: base: Add prototype declaration to the header file")
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Rashika Kheria <rashika.kheria@gmail.com>
> > CC: Nathan Fontenot <nfont@austin.ibm.com>
> > CC: Anton Blanchard <anton@au1.ibm.com>
> > CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> > CC: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  include/linux/memory.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > index bb7384e3c3d8..8b8d8d12348e 100644
> > --- a/include/linux/memory.h
> > +++ b/include/linux/memory.h
> > @@ -35,7 +35,7 @@ struct memory_block {
> >  };
> >
> >  int arch_get_memory_phys_device(unsigned long start_pfn);
> > -unsigned long __weak memory_block_size_bytes(void);
> > +unsigned long memory_block_size_bytes(void);
> >
> >  /* These states are exposed to userspace as text strings in sysfs */
> >  #define        MEM_ONLINE              (1<<0) /* exposed to userspace */
> >
 
s390 works fine with the __weak on memory_bloc_size_bytes.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

