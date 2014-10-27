Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaJ0Xl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:41:57 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47680 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaJ0Xl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <544EC59D.9080303@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
	<CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
Date: Mon, 27 Oct 2014 16:41:55 -0700
X-Google-Sender-Auth: y3MbwNtYH3K7_u3Hq2s5ZGxDQ3g
Message-ID: <CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 3:22 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello,
>
> On 27-10-14 18:23, Yinghai Lu wrote:
>>
>>
>> 04:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892
>>
>> So that ITE will not work after suspend/resume?
>>
> Even after the first one already, you mean?

Yes.

>
> Honestly, I don't really know what its purpose is, and it doesn't have any
> child nodes in the PCI tree from what I can tell. Possibly because I don't
> have any PCI cards in the machine, just a PCIe video card - assuming this is
> a PCI bridge taking care of legacy PCI plugin cards?
>
>> Please apply 4 attached patches and try to remove the device like
>>
>> echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/remove
>> echo 1 > /sys/bus/pci/devices/0000\:00\:1c.3/pcie_link_disable
>>
>> before suspend/resume test.
>>
> That worked! Resumed properly now.
>
> Full log in http://gaast.net/~wilmer/.lkml/good3.17.txt . Including the PCI
> dump at boot time, where that device doesn't dump just ff's.

Can you only apply the patch that revert enable bridge early and
two pci dump patches to see if 04:00.0 readout is 0xff?

Thanks

Yinghai
