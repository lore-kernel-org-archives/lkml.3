Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3JDUV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:21:57 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53595 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JDUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130928175548.8612.84198.stgit@amt.stowe>
References: <20130928175548.8612.84198.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 14:21:34 -0600
Message-ID: <CAErSpo69K-xJsjRHYTtZOu+NjZuvegc3n+y1v1dUdQ+TtdNDbA@mail.gmail.com>
Subject: Re: [PATCH] cris/PCI: Remove pci_mem_start
To: Myron Stowe <myron.stowe@redhat.com>
Cc: starvik@axis.com, jesper.nilsson@axis.com, linux-cris-kernel@axis.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 11:55 AM, Myron Stowe <myron.stowe@redhat.com> wrote:
> Remove unused 'pci_mem_start' variable.
>
> CC: Mikael Starvik <starvik@axis.com>
> CC: Jesper Nilsson <jesper.nilsson@axis.com>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Applied to pci/misc, thanks!

It'd be nice if we could someday get rid of PCIBIOS_MIN_IO and
PCIBIOS_MIN_MEM, too.  They're really just relics from the days when
we assumed there was a single host bridge, and we didn't have any idea
what the host bridge apertures were (or we assumed the host bridge
essentially subtractively decoded everything).

Now that we can tell the PCI core about host bridge apertures, the
arch should be able to achieve the effect of PCIBIOS_MIN_MEM by
clipping the window itself.

Bjorn

> ---
>
>  arch/cris/include/asm/pci.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/cris/include/asm/pci.h b/arch/cris/include/asm/pci.h
> index 146da90..f666734 100644
> --- a/arch/cris/include/asm/pci.h
> +++ b/arch/cris/include/asm/pci.h
> @@ -11,7 +11,6 @@
>
>  #define pcibios_assign_all_busses(void) 1
>
> -extern unsigned long pci_mem_start;
>  #define PCIBIOS_MIN_IO         0x1000
>  #define PCIBIOS_MIN_MEM                0x10000000
>
>
