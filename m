Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3K1OSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:18:07 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47255 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3K1OSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:18:05 -0500
Date: Thu, 28 Nov 2013 14:15:13 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        cl91tp@gmail.com, tianyu.lan@intel.com, khlebnikov@openvz.org,
        indou.takao@jp.fujitsu.com, jility09@gmail.com, f.otti@gmx.at,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131128141513.3de95d04@alan.etchedpixels.co.uk>
In-Reply-To: <20131127220106.GA21887@kroah.com>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
	<87ob55my8z.fsf@xmission.com>
	<52964F2C.1020803@oracle.com>
	<20131127212227.GA31237@kroah.com>
	<20131127215309.GA15320@srcf.ucam.org>
	<20131127220106.GA21887@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, I really don't care either way, but this seems like something
> that the drivers should be doing.  What suddenly changed that caused
> this problem to occur that hasn't happened in the years prior to now
> that drives this to be a stable-kernel issue?

When this first went in I pointed out it was an utterly stupid idea.
Since it went in lots of machines haven't rebooted properly or powered
off right.

There are two problems

1. Clearing the busmaster bit is not well defined behaviour. It even
freezes some hardware.

2. Lots of PC class hardware has firmware which believes that it can
access the hardware as it goes to reboot or poweroff and that someone
won't have shut it down.

Like it or not the firmware expected behaviour for such things is "what
Windows did". The expected PC behaviour is subtle and magic - eg the fact
D3 on some IDE disk controllers is terminal until power cycled because
Windows didn't do that or that the BIOS goes off and chats to the disks
in reboot without assuming the disk controller is completely
uninitialized.

kexec is a special cornercase and handling is as such (knowing it will
bother to re-init appropriate devices) is very different to the current
broken behaviour for PC systems.

Alan
