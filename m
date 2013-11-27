Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3K0Vx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:53:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab3K0VxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:53:23 -0500
Date: Wed, 27 Nov 2013 13:53:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Maximilian Attems <maks@stro.at>
Subject: Re: [PATCH] parport: parport_pc: remove double PCI ID for NetMos
Message-Id: <20131127135322.49ea91c23db4879f97b524f0@linux-foundation.org>
In-Reply-To: <1385570623-20260-1-git-send-email-bigeasy@linutronix.de>
References: <1385570623-20260-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 17:43:43 +0100 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> In commit 85747f ("PATCH] parport: add NetMOS 9805 support") Max added
> the PCI ID for NetMOS 9805 based on a Debian bug report from 2k4 which
> was at the v2.4.26 time frame. The patch made into 2.6.14.
> Shortly before that patch akpm merged commit 296d3c783b ("[PATCH] Support
> NetMOS based PCI cards providing serial and parallel ports") which made
> into v2.6.9-rc1.
> Now we have two different entries for the same PCI id.
> I have here the NetMos 9805 which claims to support SPP/EPP/ECP mode.
> This patch takes Max's entry for titan_1284p1 (base != -1 specifies the
> ioport for ECP mode) and replaces akpm's entry for netmos_9805 which
> specified -1 (=none). Both share the same PCI-ID (my card has subsystem
> 0x1000 / 0x0020 so it should match PCI_ANY).
> 
> While here I also drop the entry for titan_1284p2 which is the same as
> netmos_9815.

Does this change have any runtime-visible effects?
