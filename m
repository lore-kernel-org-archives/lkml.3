Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaLIHVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:21:02 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61379 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaLIHVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141209022601.GA16207@richard>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
	<20141209001119.GA24661@shangw>
	<20141209022601.GA16207@richard>
Date: Mon, 8 Dec 2014 23:20:59 -0800
X-Google-Sender-Auth: 0su1I0FoIRmP64Y_omPmgNDO9WY
Message-ID: <CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 6:26 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
> On Tue, Dec 09, 2014 at 11:11:19AM +1100, Gavin Shan wrote:
>>
>>I'm going to give it a spin and Richard, could you please apply Yinghai's
>>patch to see if your SRIOV code can work properly?
>>
>
> I did a quick test on my machine. This patch doesn't affect the MMIO
> allocation on out platform, so SRIOV works fine.
>
> I will spend more time to read the patch to get more understanding about the
> problem.

Hi Marek,

Can you boot following branch with "debug ignore_loglevel pci=realloc"
on your setup?

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-allocate-fit-3.18

it has
8f74af9: PCI, x86: Allocate mmio near end of free range
1ff91c1: PCI: Don't allocate small resource in big free space.
108b43b: resources: Add allocate_resource_fit()
b6a22f0: resources: Make find_resource could return just fit resource
cf50e16: resources: Split out __allocate_resource()

on top the v3.18, and it will allocate resource in fit way.

Thanks

Yinghai
