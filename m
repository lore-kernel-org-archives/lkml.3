Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3ENPKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:10:37 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38619 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3ENPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <51925136.5050302@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
	<1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com>
	<5191F53E.4000305@cn.fujitsu.com>
	<51925136.5050302@gmail.com>
Date: Tue, 14 May 2013 08:10:33 -0700
X-Google-Sender-Auth: MUp64lamnyqBgZ_G8auqtQhpiK8
Message-ID: <CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
From: Yinghai Lu <yinghai@kernel.org>
To: Liu Jiang <liuj97@gmail.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Linux-Scsi <linux-scsi@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 7:59 AM, Liu Jiang <liuj97@gmail.com> wrote:
> On 05/14/2013 04:26 PM, Gu Zheng wrote:
>     I suggest to use pci_release_dev() instead because it also needs to
> release OF related resources.
> I will update it in next version.
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bc075a3..2ac6338 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1281,7 +1281,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus
> *bus
>         pci_set_of_node(dev);
>
>         if (pci_setup_device(dev)) {
> -               kfree(dev);
> +               pci_release_dev(&dev->dev);
>                 return NULL;

no, should move pci_set_of_node calling into pci_setup_device.

Yinghai
