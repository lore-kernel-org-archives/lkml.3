Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3LPKtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:49:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:54384 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3LPKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:49:29 -0500
Date: Mon, 16 Dec 2013 11:49:27 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <iamjoonsoo.kim@lge.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: possible regression on 3.13 when calling flush_dcache_page
Message-ID: <20131216104927.GA9627@ldesroches-Latitude-E6320>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	iamjoonsoo.kim@lge.com
References: <20131212143149.GI12099@ldesroches-Latitude-E6320>
 <20131212171322.GT4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131212171322.GT4360@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:13:22PM +0000, Russell King - ARM Linux wrote:
> On Thu, Dec 12, 2013 at 03:31:50PM +0100, Ludovic Desroches wrote:
> > I'll investigate on atmel-mci driver side but if someone has also this
> > issue or see what is wrong in the driver, please tell me all about it.
> 
> I'm not entirely sure what's causing this, but calling flush_dcache_page()
> from an IRQ isn't the best idea, as one of its side effects will be to
> unmask IRQs at the CPU.
> 

Thans for pointing this point. Having a look to other mmc drivers, it
seems flush_dcache_page() is also called from an IRQ. Not sure that
deferring it is the way to go.

What should be the most proper solution?

> BTW, the faulting function seems to have been removed in more recent
> kernels.

Same error with rc4 and linux-next.
