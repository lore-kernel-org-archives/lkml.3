Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaAJRGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:06:51 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53737 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaAJRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140110094132.GC3444@yanx>
References: <1387485843-17403-1-git-send-email-yinghai@kernel.org>
	<1387485843-17403-3-git-send-email-yinghai@kernel.org>
	<CAErSpo5VWREGptW0MU0wLJUa3h23DXMZPGkdJFMTx5WAGL8J6Q@mail.gmail.com>
	<CAE9FiQU88EO=e+CR7RKnZ6r7ofSwi9J1QisnrnDyDz6Qh367YQ@mail.gmail.com>
	<CAE9FiQVZ9yrcViFNx5q65ot=nNP=JBuvotpEjUis2FF11wjg6w@mail.gmail.com>
	<20140110094132.GC3444@yanx>
Date: Fri, 10 Jan 2014 09:06:46 -0800
X-Google-Sender-Auth: azT37pEPaLvSyeU_Rkz-vIyT0Uw
Message-ID: <CAE9FiQUw7pubrKcK6yubSXtV60BZaH+ZhsDKieiyQ0api=peXA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] PCI: Try best to allocate pref mmio 64bit above 4g
From: Yinghai Lu <yinghai@kernel.org>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 1:41 AM, Guo Chao <yan@linux.vnet.ibm.com> wrote:
> On Wed, Jan 08, 2014 at 03:34:54PM -0800, Yinghai Lu wrote:
> Just FYI, a Mellanox net card failed after exactly this patch.
>
> 3.13-rc7 + bjorn's series is OK. After this patch applied, Mellanox
> driver complains:
>
>  |mlx4_core 0003:05:00.0: Multiple PFs not yet supported.  Skipping PF.
>  |mlx4_core: probe of 0003:05:00.0 failed with error -22
>
> This is caused by MMIO read from BAR 0 (64-bit non-prefetchable) returns
> non-zore value.
>
> Resource assignment, as far as we can see, works fine. The noticable
> effect of this patch is putting ROM BAR under non-prefetachable. I try
> to revert this effect by adding MEM_64 to its ROM resource and it works
> again (system does not expose 4G above aperture yet). Not sure what's
> the root cause, looks like a driver/firmware/hardware defect.

Interesting. Can you  post boot log with "debug ignore_loglevel initcall_debug"
and with/without this patch?

Thanks

Yinghai
