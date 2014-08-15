Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaHOTOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:14:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:58108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaHOTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:14:10 -0400
Message-ID: <53EE5BF8.3010007@linutronix.de>
Date: Fri, 15 Aug 2014 21:14:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] 8250-core based serial driver for OMAP + DMA
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <20140815181704.GH17769@csclub.uwaterloo.ca>
In-Reply-To: <20140815181704.GH17769@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 08:17 PM, Lennart Sorensen wrote:

> Are you saying that with the new driver you have to respond to the RX
> irq faster than before to avoid overflows?  It is not quite clear.

Yes. The irq fires 46 bytes giving you 16 bytes buffer before overflow
vs 63 bytes buffer the old one had.

> I do think 40000 interrupts to handle 40000 bytes of date does seem a
> tad inefficient, so dropping to 854 looks a lot nicer.  Was the omap
> driver not using the fifo trigger levels at all?

It configured the trigger levels to 1 for RX and 16 for TX.

Sebastian
