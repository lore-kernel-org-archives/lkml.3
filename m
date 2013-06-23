Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3FWVlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:41:50 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48343 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3FWVlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:41:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
Date: Sun, 23 Jun 2013 23:51:08 +0200
Message-ID: <4594257.0MqNgJk35h@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51C71AFA.4090102@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <4437606.laqX8rCptb@vostro.rjw.lan> <51C71AFA.4090102@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 23, 2013 11:57:46 PM Jiang Liu wrote:
> On 06/23/2013 03:59 AM, Rafael J. Wysocki wrote:
> > On Saturday, June 22, 2013 10:47:24 AM Jiang Liu wrote:
> >> On 06/22/2013 08:13 AM, Rafael J. Wysocki wrote:
> >>> On Saturday, June 22, 2013 12:54:21 AM Jiang Liu wrote:
> >>>> On 06/21/2013 03:06 AM, Rafael J. Wysocki wrote:
> >>>>> On Wednesday, June 19, 2013 11:18:41 AM Alexander E. Patrakov wrote:
> >>>>>> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >>>>>>> OK, let's try to untangle this a bit.
> >>>>>>>
> >>>>>>> If you applyt patches [1/4] and [4/4] from the $subject series only, what
> >>>>>>> does remain unfixed?
> >>>>>>
> >>>>>> [not tested, can do so in 12 hours if needed]
> >>>>>>
> >>>>>> I think there will be problems on undocking and/or on the second
> >>>>>> docking, as described in comments #6 - #8 of
> >>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=59501
> >>>>>
> >>>>> OK, I think I have something that might work.  It may not solve all problems,
> >>>>> but maybe it helps a bit.  Unfortunately, I can't really test it, so please do
> >>>>> if you can.
> >>>>>
> >>>>> Please apply [1/4] and [4/4] and the one below and see what happens.
> >>>>>
> >>>>> Thanks,
> >>>>> Rafael
> >>>>>
> >>>>>
> >>>>> ---
> >>>>> Rationale:
> >>>>> 	acpiphp_glue.c:disable_device() trims the underlying ACPI device objects
> >>>>> 	after removing the companion PCI devices, so the dock station code
> >>>>> 	doesn't need to trim them separately for the dependent devices handled
> >>>>> 	by acpiphp.
> >>>>>
> >>>>> 	Moreover, acpiphp_glue.c is the only user of
> >>>>> 	[un]register_hotplug_dock_device(), so *all* devices on the
> >>>>> 	ds->hotplug_devices list are handled by acpiphp and ops is set for all
> >>>>> 	of them.
> >>>> Hi Rafael,
> >>>>     There's an ongoing patch to fix a disk bay hotplug regression, which
> >>>> may add a second caller of register_hotplug_device(). Please refer to
> >>>> bug 59871, and the proposed patch is at:
> >>>> https://bugzilla.kernel.org/attachment.cgi?id=105581
> >> Hi Rafael,
> >>     You can find the proposed patch for ATA Bay hotplug at
> >> https://bugzilla.kernel.org/attachment.cgi?id=105581
> > 
> > Well, maybe it'll have to be reworked slightly.
> > 
> > Which BZ entry is that?
> Hi Rafael,
> 	It's bug 59871, please refer to:
> https://bugzilla.kernel.org/show_bug.cgi?id=59871

OK, thanks!

I suppose it would be most convenient to simply add that patch to this
patchset.

Thanks,
Rafael

