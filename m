Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3AOLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:16:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41160 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab3AOLQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:16:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 07/22] ACPI: Separate acpi_bus_trim to support two steps.
Date: Tue, 15 Jan 2013 12:22:47 +0100
Message-ID: <13748380.3EEdbDmJs6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXDSjzXPudWCG9fkDDO0ksncWcSQon5nhA2NLagidO1qQ@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <3028581.u7PNshx4kV@vostro.rjw.lan> <CAE9FiQXDSjzXPudWCG9fkDDO0ksncWcSQon5nhA2NLagidO1qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 10:31:35 PM Yinghai Lu wrote:
> On Sat, Jan 12, 2013 at 2:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, January 11, 2013 02:40:34 PM Yinghai Lu wrote:
> >> Current all acpi_bus_trim callers have rmdevice to 1.
> >> that means it will remove all acpi devices.
> >>
> >> When 0, is passed, it will keep the parent.
> >>
> >> For root bus hotremove support, we need to have pci device to be
> >> removed before acpi devices.
> >>
> >> So try to keep all acpi devices, and only stop drivers with them.
> >>
> >> This change should be safe because all current callers all have 1 passed.
> >
> > I'm not sure how the chanelog is related to the patch itself.
> >
> > The patch modifies the behavior of acpi_bus_trim() to avoid removing all
> > devices (not just the start point) for rmdevice==0, which doesn't really change
> > the functionality, because all callers pass rmdevice=1 anyway.
> >
> > Yes, we can make this change, but why is it necessary?
> >
> > And why don't we remove the rmdevice argument from acpi_bus_trim() altogether?
> 
> this patch is not needed after your changes with acpi_bus_trim.

OK, cool. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
