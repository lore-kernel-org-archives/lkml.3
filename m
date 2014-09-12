Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaILJv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:51:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:46517 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaILJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:51:28 -0400
Message-ID: <5412C21A.8020203@linutronix.de>
Date: Fri, 12 Sep 2014 11:51:22 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <20140911151114.GD28458@ci00147.xsens-tech.local> <5411C810.7070906@linutronix.de> <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com> <54129F6C.7040508@linutronix.de> <20140912094010.GE28458@ci00147.xsens-tech.local>
In-Reply-To: <20140912094010.GE28458@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 11:40 AM, Frans Klaver wrote:

> I'm not sure. I just reproduced this on a boneblack, using your uart_v9
> branch.
> 
>> This problem only pops-up if you use DMA. With disabled DMA you don't
>> see this, right?
> 
> I get the lockup both with and without DMA enabled. Here's the 8250
> config I use. Our full .config is attached in case it may provide
> something relevant.

Hmm. I have a bone black here. Can you tell what you did to get this
lockup? The port configuration (unless 115200 8N1) and what you did to
get this lockup.

> Something that may also help: when I have a lockup on the boneblack, dma
> is enabled and something is written to console like I described earlier,
> I get the following bad irq:

> Full dmesg is also attached.

This one should be stuffed by this:
	"[RFC] ARM: edma: unconditionally ack the error interrupt"
	https://lkml.org/lkml/2014/9/10/714

> Hope you find something useful in there.

> Thanks,
> Frans

Sebastian
