Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3GQNhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:37:38 -0400
Received: from transistor.pcserviceselectronics.co.uk ([87.127.8.169]:40306
	"EHLO pcserviceselectronics.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896Ab3GQNhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:37:36 -0400
X-Greylist: delayed 1910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 09:37:36 EDT
Message-ID: <51E696B0.3050808@pcserviceselectronics.co.uk>
Date: Wed, 17 Jul 2013 14:05:52 +0100
From: Paul Carpenter <paul@pcserviceselectronics.co.uk>
Organization: PC Services (Reading)
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What endianness is word in i2c_smbus_data?
References: <CALCETrUKK2j17LP+dVe61UCj05w914RRgyGXhorP1nfS7=rKnA@mail.gmail.com>
In-Reply-To: <CALCETrUKK2j17LP+dVe61UCj05w914RRgyGXhorP1nfS7=rKnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:
> I'm rather confused here.  In SMBUS, the "read word" operation returns
> two bytes.  Just to be confusing, the SMBUS spec calls the first byte
> "Data Byte Low" and the second byte "Data Byte High".  But they really
> are the first and second bytes -- Read Word will return whatever Read
> Byte would have as its first byte.  Let's call these bytes B1 and B2
> for first and second.

No that tells you WHATEVER the HOST endianness the bus transfer is
always treated the same, so when two bytes are combined (into a word,
the first will be the low byte for the HOST and the second will be the
high byte for the HOST. These may actually be different for the SLAVE
device.

> The eeprom and at24 drivers expect data->word to be (B2 << 8) | B1.
> That is, data->word is the cpu representation of the value on the bus
> if that value is treated as little-endian.  Is that indeed the correct
> interpretation?  If so, should it be documented somewhere?

Several I2C devices eg PCF8575 and MCP23017 often give 16 bit results as
2 byte transfers, knowing which byte order from device to bus to host
needs matching.

So knowing that a word is made up of bytes transmitted or received in a
particular order is important as some devices do transmit high byte
first.

> --Andy
> 


-- 
Paul Carpenter          | paul@pcserviceselectronics.co.uk
<http://www.pcserviceselectronics.co.uk/>    PC Services
<http://www.pcserviceselectronics.co.uk/pi/>  Raspberry Pi Add-ons
<http://www.pcserviceselectronics.co.uk/fonts/> Timing Diagram Font
<http://www.gnuh8.org.uk/>  GNU H8 - compiler & Renesas H8/H8S/H8 Tiny
<http://www.badweb.org.uk/> For those web sites you hate
