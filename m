Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3AUWkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:40:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48559 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab3AUWkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:40:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 3/8] PCI: add a blocking notifier chain for PCI bus addition/removal
Date: Mon, 21 Jan 2013 23:46:01 +0100
Message-ID: <5013258.Ciel1uViim@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50FD6A6F.1080408@gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <3583141.yG8QGivRYt@vostro.rjw.lan> <50FD6A6F.1080408@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 12:18:55 AM Jiang Liu wrote:
> On 01/21/2013 07:54 AM, Rafael J. Wysocki wrote:
> > On Saturday, January 19, 2013 12:07:41 AM Jiang Liu wrote:
> >> When adding/removing a PCI bus, some other components want to be
> snip
> >> +
> >> +void pci_bus_call_notifier(struct pci_bus *bus, unsigned long code)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = blocking_notifier_call_chain(&pci_bus_notifier_chain,
> >> +					   code, bus);
> >> +	WARN_ON(ret != NOTIFY_DONE && ret != NOTIFY_OK);
> > 
> > I'm not sure if this is a good idea.  WARN_ON() is quite a heavy tool.
> Hi Rafael,
> 	How about WARN_ONCE() here?

Well, that depends on what you think it will be useful for.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
