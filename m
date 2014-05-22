Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaEVQ6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:58:42 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56187 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaEVQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:58:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405220845150.1594@denkbrett>
References: <20140522140916.1a5f3801@canb.auug.org.au> <alpine.LFD.2.11.1405220845150.1594@denkbrett>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 May 2014 10:58:18 -0600
Message-ID: <CAErSpo6BK=_4XhPVSjw==R0x2_GR4LHf0sZ4KaX_jVY+CXEh+g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pci tree
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 12:49 AM, Sebastian Ott
<sebott@linux.vnet.ibm.com> wrote:
> Hello,
>
> On Thu, 22 May 2014, Stephen Rothwell wrote:
>> Hi Bjorn,
>>
>> After merging the pci tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>> drivers/pci/pci-sysfs.c: In function 'devspec_show':
>> drivers/pci/pci-sysfs.c:426:22: error: dereferencing pointer to incomplete type
>> drivers/pci/pci-sysfs.c:428:30: error: dereferencing pointer to incomplete type
>> drivers/pci/pci-sysfs.c:429:1: warning: control reaches end of non-void function [-Wreturn-type]
>>
>> Caused by commit da647bb30834 ("PCI: Move Open Firmware devspec
>> attribute to PCI common code").  Presumably a forgotten include.
>>
>> I have used the pci tree from next-20140521 for today.
>
> Oops, sry for that one - this should fix it:
>
> pci: fix compile failure on arm
>
> Fix this compile error introduced by "PCI: Move Open Firmware
> devspec attribute to PCI common code":
>
> drivers/pci/pci-sysfs.c: In function 'devspec_show':
> drivers/pci/pci-sysfs.c:426:22: error: dereferencing pointer to incomplete type
> drivers/pci/pci-sysfs.c:428:30: error: dereferencing pointer to incomplete type
> drivers/pci/pci-sysfs.c:429:1: warning: control reaches end of non-void function [-Wreturn-type]
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

I folded this in and updated my "next" branch, thanks!

> ---
>  drivers/pci/pci-sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 4e0acef..d6e61ae 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/vgaarb.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/of.h>
>  #include "pci.h"
>
>  static int sysfs_initialized;  /* = 0 */
> --
> 1.8.5.5
>
