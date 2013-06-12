Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3FLCtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 22:49:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63576 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3FLCts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 22:49:48 -0400
Message-ID: <51B7E1C7.9030004@gmail.com>
Date: Wed, 12 Jun 2013 10:49:43 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPIPHP: fix device destroying order issue in handling
 dock notification
References: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com> <CAN_LGv1hrLnYkPHycyyd35ZipWWznXM_0cdj8Rnh1WxiTZL=4A@mail.gmail.com> <51B7170E.2060608@gmail.com> <CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com> <51B73BAB.3030406@gmail.com> <CAN_LGv3iwgp_8dkt1ouCD-FFGau3h7L25ORUW2J-rz30_4ZYTA@mail.gmail.com>
In-Reply-To: <CAN_LGv3iwgp_8dkt1ouCD-FFGau3h7L25ORUW2J-rz30_4ZYTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12 Jun 2013 12:51:59 AM CST, Alexander E. Patrakov wrote:
> 2013/6/11 Jiang Liu <liuj97@gmail.com>:
>> Hi Alexander,
>>     This is much more harder issue to resolve.  Let's first work around
>> this
>> issue and check whether other things are OK. The patch below is just a
>> prove of concept, could you please help to try it?
>
> In the initially-undocked case it passes the "dock and undock three
> times, verify lspci output at each step" test.
>
> In the initially-docked case, it exhibits the following problem: when
> I press the undock button, only one PCI device disappears, and the
> "docked" LED does not turn off. Additionally, there is a hung task.
Hi Alexander,
     In the initially-docked case, the failure is caused by an issue in
the intel sound card driver. Seems something is wrong with reference
count management and it never returns to zero on driver detach.
Could you please help to disable the Intel sound card driver and try
again?

I'm not familiar with Intel HDA driver,  so please help to fire another
bug for it.

Regards!
Gerry

>
> Both dmesgs are attached.
>


