Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaI2J4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:56:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:49888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaI2J4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:56:49 -0400
Date: Mon, 29 Sep 2014 11:56:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: linux-serial@vger.kernel.org, tony@atomide.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/16] tty: serial: 8250_dma: add pm runtime
Message-ID: <20140929095645.GC13142@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-14-git-send-email-bigeasy@linutronix.de>
 <20140929092606.GC13952@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140929092606.GC13952@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-29 11:26:06 [+0200]:

>On Wed, Sep 10, 2014 at 09:30:08PM +0200, Sebastian Andrzej Siewior wrote:
>> There is nothing to do for RPM in the RX path. If the HW goes off then it
>> won't assert the DMA line and the transfer won't happen. So we hope that
>> the HW does not go off for RX to work (DMA or PIO makes no difference
>> here).
>> 
>> For TX the situation is slightly different. RPM is enabled on
>> start_tx(). We can't disable RPM on DMA complete callback because there
>> is still data in the FIFO which is being sent. We have to wait until
>> the FIFO is empty before we disable it.
>> For this to happen we fake a TX sent error and enable THRI. Once the
>> FIFO is empty we receive an interrupt and since the TTY-buffer is still
>> empty we "put RPM" via __stop_tx(). Should it been filed then in the
>> start_tx() path we should program the DMA transfer and remove the error
>> flag and the THRI bit.
>
>That last sentence starts out a bit messy.

This got mered so there is nothing I can do about it anymore. But I will
try to fix comments in code where and in patches that are not yet merged
(what you report :))

Sebastian
