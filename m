Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaIESUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:20:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34160 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaIESUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:20:47 -0400
Date: Fri, 5 Sep 2014 20:20:44 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Jason Cooper <jason@lakedaemon.net>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Fix uninitialized variable in
 mvebu_get_tgt_attr()
Message-ID: <20140905202044.4c166a43@free-electrons.com>
In-Reply-To: <20140905174122.GD8080@google.com>
References: <1407512045-26969-1-git-send-email-geert+renesas@glider.be>
	<20140905174122.GD8080@google.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Bjorn Helgaas,

On Fri, 5 Sep 2014 11:41:22 -0600, Bjorn Helgaas wrote:

> This fix looks right to me.  I added a stable tag as follows.  Thomas
> and/or Jason, and you ack this?

Hum, I think I would actually prefer something like:

                if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
                        rtype = IORESOURCE_IO;
                else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
                        rtype = IORESOURCE_MEM;
+		else
+			continue;

So that we're explicit with the fact that we only care about I/O and
MEM32 resource types.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
