Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3DOSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:09:58 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46053 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3DOSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <1366030138-71292-2-git-send-email-huawei.libin@huawei.com>
References: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com> <1366030138-71292-2-git-send-email-huawei.libin@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 15 Apr 2013 12:09:34 -0600
Message-ID: <CAErSpo6zpqkVZA-tbb8zXd9=WQ71JUCNPwDzx=009=Kv8tHgGw@mail.gmail.com>
Subject: Re: [PATCH 2/6] PCI: use vma_pages() to replace (vm_end - vm_start)
 >> PAGE_SHIFT
To: Libin <huawei.libin@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-mm@kvack.org, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 6:48 AM, Libin <huawei.libin@huawei.com> wrote:
> (*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
> as a inline funcion vma_pages() in linux/mm.h, so using it.
>
> Signed-off-by: Libin <huawei.libin@huawei.com>

Applied to my pci/misc branch for v3.10, thanks!

Bjorn

> ---
>  drivers/pci/pci-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9c6e9bb..5b4a9d9 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -897,7 +897,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
>
>         if (pci_resource_len(pdev, resno) == 0)
>                 return 0;
> -       nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +       nr = vma_pages(vma);
>         start = vma->vm_pgoff;
>         size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
>         pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
> --
> 1.8.2.1
>
>
