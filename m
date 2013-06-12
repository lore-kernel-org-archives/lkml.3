Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3FLSh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:37:29 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52260 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3FLSh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <51B7E1C7.9030004@gmail.com>
References: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1hrLnYkPHycyyd35ZipWWznXM_0cdj8Rnh1WxiTZL=4A@mail.gmail.com>
	<51B7170E.2060608@gmail.com>
	<CAN_LGv26adLa5RBhwhCfvALFx78j4HdvzVH1PaAuhvWXSeqyMw@mail.gmail.com>
	<51B73BAB.3030406@gmail.com>
	<CAN_LGv3iwgp_8dkt1ouCD-FFGau3h7L25ORUW2J-rz30_4ZYTA@mail.gmail.com>
	<51B7E1C7.9030004@gmail.com>
Date: Thu, 13 Jun 2013 00:37:25 +0600
Message-ID: <CAN_LGv3Cqw6gyhy3qDBeh9b1QmHpsQrJkZg-jRrLO2YOfvyLAA@mail.gmail.com>
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

2013/6/12 Jiang Liu <liuj97@gmail.com>:
> Hi Alexander,
>      In the initially-docked case, the failure is caused by an issue in
> the intel sound card driver. Seems something is wrong with reference
> count management and it never returns to zero on driver detach.
> Could you please help to disable the Intel sound card driver and try
> again?

I have discussed the problem with pulseaudio developers. According to
my understanding (that may be wrong), we have a classic ABBA deadlock.
The device will go away when its reference count goes to zero. The
reference count will go to zero when there are no open fds. The mixer
fd will be closed when it gets a -EIO, i.e. after the device goes
away.

If the above understanding is correct, I think that waiting for zero
references should be at least questioned.

-- 
Alexander E. Patrakov
