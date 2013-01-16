Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab3APAQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:16:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41541 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469Ab3APAQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:16:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
Date: Wed, 16 Jan 2013 01:22:35 +0100
Message-ID: <3905799.Wx2ixLIOL7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2102023.Itn3WlmlaN@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <CAE9FiQW-efB2s1gdmVTy8k9NLSayAxfkTFvtzQhzL6MFBFSoWQ@mail.gmail.com> <2102023.Itn3WlmlaN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 12:55:20 AM Rafael J. Wysocki wrote:
> On Tuesday, January 15, 2013 03:43:17 PM Yinghai Lu wrote:
> > On Tue, Jan 15, 2013 at 3:26 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Monday, January 14, 2013 10:55:49 PM Yinghai Lu wrote:
[...]
> > 
> > 
> > looks like:
> > 
> > acpi_device_release+0x30
> > 0xffffffff81536e2f is in acpi_device_release (drivers/acpi/scan.c:524).
> > 519	static void acpi_free_power_resources_lists(struct acpi_device *device)
> > 520	{
> > 521		int i;
> > 522	
> > 523		acpi_power_resources_list_free(&device->wakeup.resources);
> > 524		if (!device->flags.power_manageable)
> > 525			return;
> > 526	
> > 527		for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
> > 528			struct acpi_device_power_state *ps = &device->power.states[i];
> > 
> > wakeup.resources has problem?
> 
> Yes, it seems to.
> 
> Thanks for the report, looking into it.

Found a bug, fixed it and updated the tree (device->flags.wakeup.valid should
be checked before the acpi_power_resources_list_free(&device->wakeup.resources),
otherwise the list may not be initialized).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
