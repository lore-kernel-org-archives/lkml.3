Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965559Ab3E2KZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:25:09 -0400
Received: from mailhost-y2-m4.netultra.net ([78.40.49.239]:58272 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965412Ab3E2KZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:25:07 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 06:25:06 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5.7235.2
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
Content-class: urn:content-classes:message
Subject: Re: [I2C] informations + advice about messages handling
Date: Wed, 29 May 2013 12:17:58 +0200
Message-ID: <CA78C307B8F06747967D122FC656B15398645D@SERVEUR0.nvp.local>
In-Reply-To: <20130524142017.52545a52@endymion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [I2C] informations + advice about messages handling
Thread-Index: Ac5cVcxTBMRJc5iYRIqJ+BJrcHlrmQ==
References: <CA78C307B8F06747967D122FC656B153986448@SERVEUR0.nvp.local> <CAK7N6vpg6QUAKODKO2Msr4+GTASLDpA2cG1teQV3yiwt7D4SSw@mail.gmail.com> <20130524094407.61d0ec42@endymion.delvare> <CA78C307B8F06747967D122FC656B15398644A@SERVEUR0.nvp.local> <20130524110706.6052493e@endymion.delvare> <CA78C307B8F06747967D122FC656B15398644B@SERVEUR0.nvp.local> <20130524142017.52545a52@endymion.delvare>
From: "Mylene Josserand" <Mylene.Josserand@navocap.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "anish singh" <anish198519851985@gmail.com>,
        "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
        "Linux I2C" <linux-i2c@vger.kernel.org>,
        "linux-kernel-mail" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Le 24/05/2013 14:20, Jean Delvare a écrit :
> On Fri, 24 May 2013 11:52:54 +0200, Mylene Josserand wrote:
>> - an audio codec tlv320aic3204 : There is a driver for this device but
>> for some reasons, we did not use it. Did not find a "SMBus compliant" in
>> its datasheet.
>
> The tlv320aic32x4 driver uses i2c_master_send, which is a shortcut to
> i2c_transfer. However it seems to only send 2 bytes on the bus at once,
> the same could be achieved with i2c_smbus_write_byte_data if needed.

Okay, thanks to have looked at it !

>
> For completeness: a device might use transactions which are compliant
> with SMBus without being formally "SMBus-compliant", because SMBus has
> more constraints than just transaction types (I kept things simple
> originally to not confuse you.) This may explain why it isn't mentioned
> in the datasheet. Or just because the manufacturer did not care because
> they target fully I2C-capable systems anyway.
>
> What you have to look at is the transaction types. They are usually
> described in the datasheet. Then compare with either the SMBus
> specification or
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/i2c/smbus-protocol
> and if they match then you can use the i2c_smbus_*() calls.


I have checked the PIC18F24201 according to your advice and, of what I 
have seen, it can handle the SMBus protocol.

Thank you for the explanation and trying to keep it simple for me :)


-- 
Mylène JOSSERAND
