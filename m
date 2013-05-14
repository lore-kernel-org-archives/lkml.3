Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab3ENNsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:48:50 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:43019 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3ENNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:48:48 -0400
Message-ID: <1368539323.4304.81.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCHv2 net 1/2] sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to
 NET_IP_ALIGN
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: David Miller <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-net-drivers@solarflare.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Tue, 14 May 2013 14:48:43 +0100
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7235@saturn3.aculab.com>
References: <1368482311.3305.48.camel@bwh-desktop.uk.solarflarecom.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7235@saturn3.aculab.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19864.005
X-TM-AS-Result: No--20.548800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 09:32 +0100, David Laight wrote:
> > The two architectures that define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > (powerpc and x86) now both define NET_IP_ALIGN as 0, so there is no
> > need for this optimisation any more.
> 
> Hmmm.... even on x86 there will be a measurable cost
> in misaligned accesses - at least for some workloads.

When they cross cache-line boundaries, yes.

Maybe napi_get_frags() should be adding the 2 byte offset on all
architectures, as the skbs it allocates are never RX DMA buffers.

> If the DMA is able to write to a mis-aligned buffer and
> still perform aligned burst transfers mid-frame then
> 4n+2 aligning the rx buffer should be a win even on x86.

I don't think so.

> Note to hardware engineers: add an option to write two
> bytes of junk before the rx data :-)

There is some hardware with that option.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

