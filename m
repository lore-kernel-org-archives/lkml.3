Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3FNDXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:23:03 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54009 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3FNDXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_LGv2HxTB_8Oo8CB2mgKKL2n-P7b7a3NySTL7zhGpDE9-PkQ@mail.gmail.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
	<CAN_LGv2HxTB_8Oo8CB2mgKKL2n-P7b7a3NySTL7zhGpDE9-PkQ@mail.gmail.com>
Date: Thu, 13 Jun 2013 20:22:58 -0700
X-Google-Sender-Auth: SQNbuJEyKT0SCKP_gAf3eF9Jnx8
Message-ID: <CAE9FiQW1VJr7g+FAW0fr1Pxd2ut-nA=_O=3BQtRNYcTtzgezfw@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: Yinghai Lu <yinghai@kernel.org>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 7:06 PM, Alexander E. Patrakov
<patrakov@gmail.com> wrote:
> 2013/6/14 Yinghai Lu <yinghai@kernel.org>:
>> the 3) is about pci resource allocation?
>> because pcibios_add_bus is called too early?
>
> (3) is https://bugzilla.kernel.org/show_bug.cgi?id=56531
>
>> If that is case, we should have something like attached patch for it.
>
> It does not even compile because the argument of pci_bus_add_devices()
> points to a const struct. You can't increment a member of it. And even
> if you remove the const from both the declaration and the definition
> of that function, the patch doesn't help at all.
>
> Here is /proc/ioports with the fixed-up patch:

dmesg with the fixed-up patch on v3.10-rc?

After look at the your dmesg v3.10-rc5, we really should move
pcibios_add_bus down.
as we do have children slots under ....

Yinghai
