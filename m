Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaHSL6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:58:34 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51990 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbaHSL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:58:31 -0400
Message-ID: <53F33BDD.8050705@hurleysoftware.com>
Date: Tue, 19 Aug 2014 07:58:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v9 12/16] serial: amba-pl011: Pass FIQ information to
 KGDB.
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <1408372091-12689-13-git-send-email-daniel.thompson@linaro.org> <53F24660.2030404@hurleysoftware.com> <53F313F2.6090103@linaro.org>
In-Reply-To: <53F313F2.6090103@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 05:08 AM, Daniel Thompson wrote:
> On 18/08/14 19:30, Peter Hurley wrote:

[cut]
  
>>> +static int pl011_poll_init(struct uart_port *port)
>>> +{
>>> +	struct uart_amba_port *uap = (struct uart_amba_port *)port;
>>
>> Please use container_of() in new code.
> 
> Ok.
> 
> Personally I dislike a file that mixes casts and conatiner_of but I
> guess I can make both of us happy by switching the whole driver to
> container_of. Separate patch again?

The change below makes the uap local unnecessary, so you can skip the
container_of() change, if you'd prefer.

>>> +	int retval;
>>> +
>>> +	retval = pl011_hwinit(port);
>>> +
>>> +#ifdef CONFIG_KGDB_FIQ
>>> +	if (retval == 0)
>>> +		kgdb_register_fiq(uap->port.irq);
>>
>> The uap->port dereference is unnecessary since the port parameter
>> is the same thing.
>>
>> 		kgdb_register_fiq(port->irq);
> 
> Ok.

Thanks,
Peter Hurley
