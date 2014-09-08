Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaIHQdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:33:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:46113 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaIHQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:33:28 -0400
Date: Mon, 8 Sep 2014 18:33:13 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: linux-serial@vger.kernel.org, tony@atomide.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140908163313.GA25724@linutronix.de>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908144616.GA22315@ci00147.xsens-tech.local>
 <20140908151501.GA22584@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140908151501.GA22584@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2014-09-08 17:15:01 [+0200]:

>* Frans Klaver | 2014-09-08 16:46:18 [+0200]:
>
>>- ncurses based applications (vi, less) don't play nice for me on the
>>  console with this series. less doesn't show me anything. vi doesn't
>>  return to console properly.
>
>Can you give a test case 

Okay. less. My am335x-evm freezes after a while for no obvious reason.
The data that hits the RX fifo is still received but the TX won't do
anything. The DMA request is pending, the FIFO level is @64 bytes and
the UART doesn't make any progress.
On beagle-board I see what you described: less on a file and nothing
happens.
Disabling DMA seems to help fix the problem omap3. Nothing changes for
am335x.

Sebastian
