Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaI2Nj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:39:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:51562 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaI2NjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:39:25 -0400
Date: Mon, 29 Sep 2014 15:39:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: linux-serial@vger.kernel.org, tony@atomide.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        mika.westerberg@linux.intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/16] tty: serial: 8250_core: add run time pm
Message-ID: <20140929133918.GE13142@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-3-git-send-email-bigeasy@linutronix.de>
 <20140929094620.GE13952@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140929094620.GE13952@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-29 11:46:20 [+0200]:

>On Wed, Sep 10, 2014 at 09:29:57PM +0200, Sebastian Andrzej Siewior wrote:
>> +/*
>> + * This two wrapper ensure, that enable_runtime_pm_tx() can be called more than
>
>These two wrappers ensure that enable_runtime_pm_tx() ...
fixed

>> @@ -1469,7 +1531,12 @@ void serial8250_tx_chars(struct uart_8250_port *up)
>>  
>>  	DEBUG_INTR("THRE...");
>>  
>> -	if (uart_circ_empty(xmit))
>> +	/*
>> +	 * With RPM enabled, we have to wait once the FIFO is empty before the
>
>s,once,until,? Or do I not understand the sentence correctly?
No, you understand it correct. "until" is the better word here.

Sebastian
