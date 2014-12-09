Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaLIK33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:29:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47092 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755404AbaLIK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:29:27 -0500
Date: Tue, 9 Dec 2014 10:29:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
Message-ID: <20141209102904.GJ11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com>
 <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com>
 <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com>
 <2863746.4sUSEYqahB@wuerfel>
 <20141208160316.GM16185@e104818-lin.cambridge.arm.com>
 <5485D97D.1040404@broadcom.com>
 <5486CCBC.3@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486CCBC.3@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 11:19:40AM +0100, Arend van Spriel wrote:
> The issue did not trigger overnight so it seems setting bit 22 <Shared
> Attribute _Override_ Enable> solves the issue over here. Now the question is
> how to move forward with this. As I understood from Catalin this patch was
> not included as it was not considered responsibility of the linux kernel.

It is preferable for firmware to configure the L2 cache appropriately,
which includes things like the prefetch offsets as well as feature bits
like bit 22.

I think what I'll do is queue up a patch which adds a warning if bit 22
is not set, suggesting that firmware is updated to set this bit.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
