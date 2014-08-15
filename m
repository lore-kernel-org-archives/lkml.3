Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaHOUVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:21:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:58333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaHOUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:21:03 -0400
Message-ID: <53EE6BA5.2060101@linutronix.de>
Date: Fri, 15 Aug 2014 22:20:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-6-git-send-email-bigeasy@linutronix.de> <20140815183731.GI17769@csclub.uwaterloo.ca> <53EE5F3F.2000707@linutronix.de> <20140815193352.GC17765@csclub.uwaterloo.ca>
In-Reply-To: <20140815193352.GC17765@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 09:33 PM, Lennart Sorensen wrote:
>> On the other hand if you use DMA then it can handle transfers > 64bytes
>> in one go and you can start transfers while the FIFO is not completely
>> empty.
> 
> You can dma more than the fifo size?

Yes. The UART asserts the DMA line as long as there is room for
$TRESHOLD number of bytes. So we never overflow the FIFO. That is why we
can't take any DMA channel but only *the* one.

>> There is patch in Greg's tty tree already where you are able to
>> configure the RX trigger level. We could wire this up once we agree
>> which levels we want support. The OMAP supports all levels from 1…63.
> 
> All? or just every 4 (that's what I just read in the DRA7xx docs).

All. Take a look at the RX_TRIGGER constant while comparing source vs
manual :)

Sebastian
