Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLESYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:24:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39756 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbaLESYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:24:54 -0500
Date: Fri, 5 Dec 2014 18:24:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205182443.GX11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com>
 <4565667.WCBuNmaazQ@wuerfel>
 <20141205111114.GQ11285@n2100.arm.linux.org.uk>
 <20141205173839.GB31222@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205173839.GB31222@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 05:38:39PM +0000, Catalin Marinas wrote:
> On Fri, Dec 05, 2014 at 11:11:14AM +0000, Russell King - ARM Linux wrote:
> > In any case, wouldn't using a u64 type for "address" be better - isn't
> > "long long" 128-bit on 64-bit architectures?
> 
> No, it's still 64-bit. There is no 128-bit integer in the C standard.

Actually, that's a fallicy.

The C99 standard (like previous versions) does not define exactly the
number of bits in each type.  It defines ranks of type, and says that
lower ranks are a subrange of integers with higher ranks (for the same
signed-ness.)  See section 6.2.5.

So, it merely states that:

range(char) <= range(short) <= range(int) <= range(long) <= range(long long)

So, an implementation could have:

char: 8  short: 16 int: 16 long: 32 long long: 64
char: 8  short: 16 int: 32 long: 32 long long: 64
char: 8  short: 16 int: 32 long: 64 long long: 64
char: 8  short: 16 int: 64 long: 64 long long: 64

or even:

char: 8  short: 16 int: 32 long: 64 long long: 128

and that would still be compliant with C99, since it continues to meet
the criteria about the required data types specified in the standard.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
