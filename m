Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3FOHZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 03:25:51 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55421 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3FOHZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 03:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
Date: Sat, 15 Jun 2013 13:25:48 +0600
Message-ID: <CAN_LGv2Y6jebtNUQ1gJYfy8uG2pxtUjT1gqMPmL+6E7myELd3A@mail.gmail.com>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/15 Alexander E. Patrakov <patrakov@gmail.com>:
> Note that the snd_hda_intel bug somehow didn't manifest itself today,
> probably because the TV that is connected to the HDMI output of the
> radeon card was off and because Xorg never really tried to use the
> card.

Well, it did. The sympthoms are the same as before: incomplete
undocking. The 16:00.1 device (HD audio controller on the radeon card)
has disappeared from lspci output, while 16:00.0 (the radeon card
itself) didn't, and the "Docked" LED didn't turn off. Fixed up by this
command:

fuser -k /dev/snd/* ; rmmod snd-hda-intel

thus confirming again that the extra references that acpiphp waits to
go away are from open fds.

-- 
Alexander E. Patrakov
