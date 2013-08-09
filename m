Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876Ab3HIJfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:35:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40842 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961Ab3HIJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:35:18 -0400
Date: Fri, 9 Aug 2013 10:35:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: DMA masks
Message-ID: <20130809093506.GN23006@n2100.arm.linux.org.uk>
References: <m3fvujgrcr.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3fvujgrcr.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:12:36AM +0200, Krzysztof Hałasa wrote:
> Hi,
> 
> I'm trying to understand why the struct device contains a pointer to
> dma_mask and not the actual dma_mask:
> 
> struct device {
>         ...
> 
>         u64             *dma_mask;      /* dma mask (if dma'able device) */
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

"If dma-able device" gives a clue.  It is now the case that the DMA API
refuses DMA (via dma_supported) if the DMA mask pointer is NULL.

So, we're now in the situation where this conveys information, and merely
getting rid of the indirection loses information which may be (and
probably is) relied upon by drivers.

However, placing the storage for the dma_mask pointer into struct device
is something which I've recently discussed with Greg, and is something
he'd like to see happen, so I'll be adding that to my DMA masks patch
series in the very near future.
