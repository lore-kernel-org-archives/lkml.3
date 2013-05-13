Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3EMHmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:42:07 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55362 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3EMHmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:42:04 -0400
Date: Mon, 13 May 2013 09:41:59 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-net-drivers@solarflare.com,
        Ben Hutchings <bhutchings@solarflare.com>,
        Stuart Hodgson <smhodgson@solarflare.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.10-rc1 (s390)
Message-ID: <20130513074159.GA4290@osiris>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
 <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
 <alpine.DEB.2.00.1305122250110.5463@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1305122250110.5463@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051307-1948-0000-0000-0000051E2154
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 10:50:45PM +0200, Geert Uytterhoeven wrote:
> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> > However, the full list of errors isn't that unmanageable, so I'm following
> > up with a digested list...
> 
> drivers/net/ethernet/sfc/efx.c:646:3: error: call to '__compiletime_assert_648' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) + EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2: 2 errors in 2 logs
> 	v3.10-rc1/s390x/s390-allyesconfig v3.10-rc1/s390x/s390-allmodconfig

that seems to a BUILD_BUG_ON that only triggers on s390, because we have
L1_CACHE_BYTES defined with 256 bytes... which seems to be more than any
other architecture has.
There was a different network driver that had a similar BUILD_BUG_ON, but
it got removed.

Right, it was the igb driver:
http://comments.gmane.org/gmane.linux.network/261378

