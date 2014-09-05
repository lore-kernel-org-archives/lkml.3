Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaIESes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:34:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65212 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaIESer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:34:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()
Date: Fri, 05 Sep 2014 20:34:14 +0200
Message-ID: <5898856.RmRf87KNto@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905202044.4c166a43@free-electrons.com>
References: <1407512045-26969-1-git-send-email-geert+renesas@glider.be> <20140905174122.GD8080@google.com> <20140905202044.4c166a43@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1wPB99fPWrLNY8Chl+w+5eAwX8GK9Yk4pXlk8WoMNyf
 MuaQsqJVGJrKjZi1DwcInotZlyqhy3s3ktOQIjFbs3sb0WpCUi
 dQ1Ag93OO/qX42DFyB5t81EegdWGxZ12lw5+TJ3xAmcEJX7BnG
 BLrK5L0jZ4BLi8Pyo4maIF6OCEMyU/MCgSK9hrxuSkbAedMgrb
 +RQjC5YP0AuEc5VI7YlrPuYPaiO32HJEFU0OshBhfHRdIRPcA9
 Le/TymnSFKu++WEc++/YW1N/4t5jWCVZxm5yKglUXVXMKK6ysZ
 0OhWeXlVXKtxsbl33iXJUUEyz3fMo6236X+so3sgzZn9nyQbbl
 +t5M79om2g+vY2eP3bhs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 20:20:44 Thomas Petazzoni wrote:
> Hum, I think I would actually prefer something like:
> 
>                 if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
>                         rtype = IORESOURCE_IO;
>                 else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
>                         rtype = IORESOURCE_MEM;
> +               else
> +                       continue;
> 
> So that we're explicit with the fact that we only care about I/O and
> MEM32 resource types.

Agreed, that looks better than my patch as well.

	Arnd
