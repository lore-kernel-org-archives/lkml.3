Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaHSMwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:52:04 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54879 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaHSMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:52:01 -0400
Message-ID: <53F34869.7050901@linaro.org>
Date: Tue, 19 Aug 2014 13:51:53 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
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
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <1408372091-12689-13-git-send-email-daniel.thompson@linaro.org> <53F24660.2030404@hurleysoftware.com> <53F313F2.6090103@linaro.org> <53F33BDD.8050705@hurleysoftware.com>
In-Reply-To: <53F33BDD.8050705@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 12:58, Peter Hurley wrote:
> On 08/19/2014 05:08 AM, Daniel Thompson wrote:
>> On 18/08/14 19:30, Peter Hurley wrote:
> 
> [cut]
>   
>>>> +static int pl011_poll_init(struct uart_port *port)
>>>> +{
>>>> +	struct uart_amba_port *uap = (struct uart_amba_port *)port;
>>>
>>> Please use container_of() in new code.
>>
>> Ok.
>>
>> Personally I dislike a file that mixes casts and conatiner_of but I
>> guess I can make both of us happy by switching the whole driver to
>> container_of. Separate patch again?
> 
> The change below makes the uap local unnecessary, so you can skip the
> container_of() change, if you'd prefer.

I realized that myself although not until after I'd replaced all the
casts with container_of()...

So I'll keep the patch for now but can drop it if anyone takes against it.



Thanks

Daniel.




> 
>>>> +	int retval;
>>>> +
>>>> +	retval = pl011_hwinit(port);
>>>> +
>>>> +#ifdef CONFIG_KGDB_FIQ
>>>> +	if (retval == 0)
>>>> +		kgdb_register_fiq(uap->port.irq);
>>>
>>> The uap->port dereference is unnecessary since the port parameter
>>> is the same thing.
>>>
>>> 		kgdb_register_fiq(port->irq);
>>
>> Ok.
> 
> Thanks,
> Peter Hurley
> 

