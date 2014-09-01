Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaIAOsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:48:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:59527 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaIAOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:48:08 -0400
Message-ID: <54048720.9000003@linutronix.de>
Date: Mon, 01 Sep 2014 16:48:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 03/15] tty: serial: 8250_core: add run time pm
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-4-git-send-email-bigeasy@linutronix.de> <20140820092319.GA20775@ci00147.xsens-tech.local> <20140820093936.GB20775@ci00147.xsens-tech.local>
In-Reply-To: <20140820093936.GB20775@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 11:39 AM, Frans Klaver wrote:

>>>  static int serial8250_get_poll_char(struct uart_port *port)
>>>  {
>>> -	unsigned char lsr = serial_port_in(port, UART_LSR);
>>> +	unsigned char lsr;
>>> +	int status;
>>> +
>>> +	serial8250_rpm_get(up);
>>
>> or up won't be defined below. You probably need 
> 
> Obviously I meant to say that 'up' won't be defined here.

Good catch, thanks. However I wouldn't bet my money it that won't be
defined here. The semaphore code provides up() and down() so it is
makes it kind of defined :) But it doesn't compile due to wrong pointer
types which is good (I run into this myself and looked confused at
first).
I didn't notice this at all because only kgdb uses this
CONFIG_CONSOLE_POLL which I had off. Once again, thank you.

>> +	struct uart_8250_port *up = up_to_u8250p(port);
>> somewhere in there.

Sebastian
