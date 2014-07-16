Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbaGPI0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:26:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:53945 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188AbaGPI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:26:43 -0400
Message-ID: <53C6373E.2010408@linutronix.de>
Date: Wed, 16 Jul 2014 10:26:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, mika.westerberg@linux.intel.com
Subject: Re: [PATCH 3/6] tty: serial: 8250 core: add runtime pm
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de> <1404928177-26554-4-git-send-email-bigeasy@linutronix.de> <20140710062812.GF28884@atomide.com>
In-Reply-To: <20140710062812.GF28884@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 08:28 AM, Tony Lindgren wrote:
>> --- a/drivers/tty/serial/8250/8250_core.c
>> +++ b/drivers/tty/serial/8250/8250_core.c
>> @@ -571,7 +573,17 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>>  			serial_out(p, UART_EFR, 0);
>>  			serial_out(p, UART_LCR, 0);
>>  		}
>> +
>> +		if (!device_may_wakeup(p->port.dev)) {
>> +			if (sleep)
>> +				pm_runtime_forbid(p->port.dev);
>> +			else
>> +				pm_runtime_allow(p->port.dev);
>> +		}
>>  	}
>> +out:
>> +	pm_runtime_mark_last_busy(p->port.dev);
>> +	pm_runtime_put_autosuspend(p->port.dev);
>>  }
> 
> The device_may_wakeup logic here is wrong as I described in the
> earlier thread. For runtime PM, the wake-up events should be
> always enabled. So the device_may_wakeup checks should be only
> done for suspend and resume.

Okay. I dropped it from here.

> 
> Regards,
> 
> Tony
> 

Sebastian
