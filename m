Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab3EXJHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:07:36 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17594 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760080Ab3EXJHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:07:34 -0400
Date: Fri, 24 May 2013 11:07:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mylene Josserand" <Mylene.Josserand@navocap.com>
Cc: "anish singh" <anish198519851985@gmail.com>,
        "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
        "Linux I2C" <linux-i2c@vger.kernel.org>,
        "linux-kernel-mail" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [I2C] informations + advice about messages handling
Message-ID: <20130524110706.6052493e@endymion.delvare>
In-Reply-To: <CA78C307B8F06747967D122FC656B15398644A@SERVEUR0.nvp.local>
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local>
	<CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com>
	<20130524094407.61d0ec42@endymion.delvare>
	<CA78C307B8F06747967D122FC656B15398644A@SERVEUR0.nvp.local>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 10:54:11 +0200, Mylene Josserand wrote:
> Ah okay ! And if there are not SMBus compliant, what function I will
> have to use ?

i2c_transfer()

> What is it doing if I use this function and that my device is not SMbus 
> compliant ?

This would make no sense. Your device understands only specific message
formats, which should be documented in its datasheet. You have to use
exactly that in your driver. If the message format matches SMBus, you
can use the SMBus API, otherwise you must use i2c_transfer() instead.

> I have some difficulties to understand the differences 
> between SMbus and I2C :(

SMBus is a subset of I2C. With I2C you can have messages of any length
and any format, with no attached semantics. SMBus restricts the
possibilities to a few standardized messages formats with semantics. If
you'd just tell us what your device is, we would be able to tell you if
SMBus will work or if I2C will be needed.

> (...)
> In my case, I have 2 segments but if I understand, the bus will not be 
> used at the same time.

I can't comment on that without knowing the exact topology. In
particular, do you have two independent segments each with its own
controller, or are they interconnected in some way? I2C/SMBus is very
simple with basic topologies but can become difficult with complex ones.

> (...)
> Okay. So the mutex blocks the I2C bus. And is it locking the bus at the 
> beginning of a message (so when a START is send) and unlocking it after 
> the STOP ?

Yes.

> So a complete message will be sent to a same device (the one which 
> address is in the data frame) ? A device can not receive a beginning of 
> one message (so with his address) and the end of another message 
> destined to another device [because of "collision"], for example ?

No, this cannot happen.

-- 
Jean Delvare
