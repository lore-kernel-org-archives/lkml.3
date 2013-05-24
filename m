Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3EXMU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:20:28 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:41220 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3EXMU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:20:27 -0400
Date: Fri, 24 May 2013 14:20:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mylene Josserand" <Mylene.Josserand@navocap.com>
Cc: "anish singh" <anish198519851985@gmail.com>,
        "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
        "Linux I2C" <linux-i2c@vger.kernel.org>,
        "linux-kernel-mail" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [I2C] informations + advice about messages handling
Message-ID: <20130524142017.52545a52@endymion.delvare>
In-Reply-To: <CA78C307B8F06747967D122FC656B15398644B@SERVEUR0.nvp.local>
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local>
	<CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com>
	<20130524094407.61d0ec42@endymion.delvare>
	<CA78C307B8F06747967D122FC656B15398644A@SERVEUR0.nvp.local>
	<20130524110706.6052493e@endymion.delvare>
	<CA78C307B8F06747967D122FC656B15398644B@SERVEUR0.nvp.local>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 11:52:54 +0200, Mylene Josserand wrote:
> Right now, my company uses the "i2c_smbus_read/write_byte_data" 
> functions to talk to devices through an application. On the datasheet of 
> these devices, I search but did not seem to be SMBus compliant.
> As it was a software which was using these functions, we thought that a 
> driver (that I would write) should be better. And here I am ! I prefer 
> to understand well the mechanism before coding anything and it is 
> interesting !

If the application was using i2c_smbus_read/write_byte_data from
user-space, then a kernel driver would call the same functions. No
reason why this wouldn't work.

> (...)
> Thanks for the explanation.
> No problem, we have 2 devices used without drivers :
> - an odometer PIC18F24201 : In the datasheet, there is a SMBus select 
> bit but I don't know if it is SMBus compliant.

Couldn't find the datasheet for this one, unfortunately.

> - an audio codec tlv320aic3204 : There is a driver for this device but 
> for some reasons, we did not use it. Did not find a "SMBus compliant" in 
> its datasheet.

The tlv320aic32x4 driver uses i2c_master_send, which is a shortcut to
i2c_transfer. However it seems to only send 2 bytes on the bus at once,
the same could be achieved with i2c_smbus_write_byte_data if needed.

For completeness: a device might use transactions which are compliant
with SMBus without being formally "SMBus-compliant", because SMBus has
more constraints than just transaction types (I kept things simple
originally to not confuse you.) This may explain why it isn't mentioned
in the datasheet. Or just because the manufacturer did not care because
they target fully I2C-capable systems anyway.

What you have to look at is the transaction types. They are usually
described in the datasheet. Then compare with either the SMBus
specification or
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/i2c/smbus-protocol
and if they match then you can use the i2c_smbus_*() calls.

> (...)
> Thanks a lot for your help !

You're welcome.

-- 
Jean Delvare
