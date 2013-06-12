Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3FLRGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:06:03 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45432 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3FLRGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_LGv0-gGMhJr8U8=sc-93e_MKVpy9TxG1MRAugtBVJP+CTrg@mail.gmail.com>
References: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1hrLnYkPHycyyd35ZipWWznXM_0cdj8Rnh1WxiTZL=4A@mail.gmail.com>
	<51B7170E.2060608@gmail.com>
	<CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com>
	<51B73BAB.3030406@gmail.com>
	<CAN_LGv3iwgp_8dkt1ouCD-FFGau3h7L25ORUW2J-rz30_4ZYTA@mail.gmail.com>
	<51B7E1C7.9030004@gmail.com>
	<CAN_LGv0-gGMhJr8U8=sc-93e_MKVpy9TxG1MRAugtBVJP+CTrg@mail.gmail.com>
Date: Wed, 12 Jun 2013 23:05:59 +0600
Message-ID: <CAN_LGv3YnBUBA2OCWmZNEBJNtP4ziQH44h0LWbnio0cj=Xm_fQ@mail.gmail.com>
Subject: Re: [PATCH] ACPIPHP: fix device destroying order issue in handling
 dock notification
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/12 Alexander E. Patrakov <patrakov@gmail.com>:
> 2013/6/12 Jiang Liu <liuj97@gmail.com>:
>> On Wed 12 Jun 2013 12:51:59 AM CST, Alexander E. Patrakov wrote:
>>> In the initially-docked case, it exhibits the following problem: when
>>> I press the undock button, only one PCI device disappears, and the
>>> "docked" LED does not turn off. Additionally, there is a hung task.
>> Hi Alexander,
>>      In the initially-docked case, the failure is caused by an issue in
>> the intel sound card driver. Seems something is wrong with reference
>> count management and it never returns to zero on driver detach.
>> Could you please help to disable the Intel sound card driver and try
>> again?
>>
>> I'm not familiar with Intel HDA driver,  so please help to fire another
>> bug for it.
>
> Thanks for pointing the finger to snd-hda-intel. With that driver
> blacklisted, the lspci output matches the expectations even after
> undocking the initially-docked laptop. Redocking re-adds the devices,
> too.

> As for snd-hda-intel bug, I will file it later today and let you know.

Actually, I debugged it further and want some input from you before
filing. Here is the new information: the incomplete undocking and hung
task does not appear if I test from a virtual console, not from an
XFCE session. The obvious difference is that in the XFCE session some
processes (the mixer applet and pulseaudio) keep the mixer device
always open.

I am not qualified enough to say what should happen if the user
presses the undock button while a program has a to-be-undocked device
open. Or, for that matter and for an analogy, if the user unplugs a
USB sound card while it is playing.

And in my case, this is going to be an issue not only because of the
snd-hda-intel driver. Xorg would sometimes keep the DRM node of the
Radeon card (that is in the dock station) open in addition to the
onboard Intel card.

--
Alexander E. Patrakov
