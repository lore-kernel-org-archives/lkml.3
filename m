Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3FEVbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:31:33 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54695 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3FEVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <1369489718-25869-8-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-8-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Jun 2013 15:31:11 -0600
Message-ID: <CAErSpo7Lbu_MuxYGa6sghu7xuDJ9ZFN8pK0=xM0QMOwr=P2Y_Q@mail.gmail.com>
Subject: Re: [PATCH v3, part1 07/10] PCI, unicore, m68k: remove redundant call
 of pci_bus_add_devices()
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc m68k and unicore32 maintainers]

On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> pci_scan_bus() and pci_scan_root_bus() has called pci_bus_add_devices()
> once, so remove the redundant call of pci_bus_add_devices().
> On the other handle, subsys_init() callbacks will be invoked before
> device_init() callbacks, so it should be safe to remove the redundant
> calls.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  arch/m68k/platform/coldfire/pci.c | 2 +-
>  arch/unicore32/kernel/pci.c       | 5 -----
>  2 files changed, 1 insertion(+), 6 deletions(-)

m68k and unicore32 guys:

I plan to apply the patch below.  I actually split it into two, one
for m68k and another for unicore32.  If you object or would rather
push it through your trees, let me know.  I don't think the rest of
the series has any actual dependency on this, so there shouldn't be
any problem if you want to take it yourselves.

Bjorn

> diff --git a/arch/m68k/platform/coldfire/pci.c b/arch/m68k/platform/coldfire/pci.c
> index 8572246..2345972 100644
> --- a/arch/m68k/platform/coldfire/pci.c
> +++ b/arch/m68k/platform/coldfire/pci.c
> @@ -320,7 +320,7 @@ static int __init mcf_pci_init(void)
>         pci_bus_size_bridges(rootbus);
>         pci_bus_assign_resources(rootbus);
>         pci_enable_bridges(rootbus);
> -       pci_bus_add_devices(rootbus);
> +
>         return 0;
>  }
>
> diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
> index ef69c0c..374a055 100644
> --- a/arch/unicore32/kernel/pci.c
> +++ b/arch/unicore32/kernel/pci.c
> @@ -277,11 +277,6 @@ static int __init pci_common_init(void)
>                 pci_bus_assign_resources(puv3_bus);
>         }
>
> -       /*
> -        * Tell drivers about devices found.
> -        */
> -       pci_bus_add_devices(puv3_bus);
> -
>         return 0;
>  }
>  subsys_initcall(pci_common_init);
> --
> 1.8.1.2
>
