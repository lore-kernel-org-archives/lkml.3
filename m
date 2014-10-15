Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJOXi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:38:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57137 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJOXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <20141015170644.4063.6843.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170644.4063.6843.stgit@bhelgaas-glaptop2.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Oct 2014 17:38:02 -0600
Message-ID: <CAErSpo4fS1fdNvur13LZVYomWdmjZnYO49Gc9BJv_BRxAXX3GA@mail.gmail.com>
Subject: Re: [PATCH v1 09/10] memory-hotplug: Remove "weak" from
 memory_block_size_bytes() declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Nathan Fontenot <nfont@austin.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rashika, Nathan, Anton, Blanchard, Heiko, Yinghai, Martin,
linux-s390; sorry, I botched my "stg mail" so you weren't included the
first time.  s390 and x86 define their own memory_block_size_bytes()
and are at risk for this problem.]

On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> drivers/base/memory.c provides a default memory_block_size_bytes()
> definition explicitly marked "weak".  Several architectures provide their
> own definitions intended to override the default, but the "weak" attribute
> on the declaration applied to the arch definitions as well, so the linker
> chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
> annotation from pcibios_get_phb_of_node decl")).
>
> Remove the "weak" attribute from the declaration so we always prefer a
> non-weak definition over the weak one, independent of link order.
>
> Fixes: 41f107266b19 ("drivers: base: Add prototype declaration to the header file")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Rashika Kheria <rashika.kheria@gmail.com>
> CC: Nathan Fontenot <nfont@austin.ibm.com>
> CC: Anton Blanchard <anton@au1.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/memory.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index bb7384e3c3d8..8b8d8d12348e 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -35,7 +35,7 @@ struct memory_block {
>  };
>
>  int arch_get_memory_phys_device(unsigned long start_pfn);
> -unsigned long __weak memory_block_size_bytes(void);
> +unsigned long memory_block_size_bytes(void);
>
>  /* These states are exposed to userspace as text strings in sysfs */
>  #define        MEM_ONLINE              (1<<0) /* exposed to userspace */
>
