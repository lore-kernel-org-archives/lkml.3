Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab3FRVQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:16:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41831 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3FRVQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:16:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
Date: Tue, 18 Jun 2013 23:25:36 +0200
Message-ID: <3943270.c6vnSkoz5G@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51C084D9.50008@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <2972274.Y9Nv7DUfsQ@vostro.rjw.lan> <51C084D9.50008@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 12:03:37 AM Jiang Liu wrote:
> On 06/17/2013 07:40 PM, Rafael J. Wysocki wrote:
> > On Monday, June 17, 2013 01:12:00 AM Jiang Liu wrote:
> >> On 06/16/2013 06:54 AM, Rafael J. Wysocki wrote:
> >>> On Saturday, June 15, 2013 11:20:40 PM Rafael J. Wysocki wrote:
> >>>> On Saturday, June 15, 2013 10:17:42 PM Rafael J. Wysocki wrote:

[...]

> Hi Rafael,

Hi,

>     I hope I could help to simplify the implementation too, but failed
> until now:(. The PCI hotplug core has the same re-entrance issue too,
> and I have struggled with that issue about one year now:(

This sounds like a design issue and we're not likely to fix design issues
in 2 weeks, with all due respect to everyone involved.  Even if someone has
an "Eureka!" moment and comes up with a really clever way to fix that issue,
we still need time to prepare patches, review them, test them etc.

>     I have tried another solution by removing ds->hp_lock and
> hotplug_devices list, please refer to the attachment. It could be used
> to solve the deadlock issue in acpiphp, but may not be used to support
> the coming fix for an ATA driver
> regression(https://bugzilla.kernel.org/show_bug.cgi?id=59871).

Please stop generating patches in a hurry.  That's not really useful.

Even if you think you know what you're doing, someone else has to understand
that too and be able to review your patches.  Honestly, my experience with
that code is kind of limited and I need more time.

>     The time window for 3.10 is closing, it would be great if we could
> reach a quick solution here.

That is clearly impossible.

My suggestion would be to apply the patches that everyone is reasonably
comfortable with at the moment and stop worrying about "time windows", because
in fact there are none.  We're talking about fixes here and we can do -stable
backports once we have a solid solution, but what matters is that this solution
has to be acceptable to *all* of us.

So please stop making it sound like the 3.10 release is a hard deadline or
something.  It is not.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
