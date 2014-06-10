Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaFJJZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:25:37 -0400
Received: from transistor.pcserviceselectronics.co.uk ([87.127.8.169]:38206
	"EHLO pcserviceselectronics.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbaFJJZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:25:34 -0400
X-Greylist: delayed 1741 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 05:25:33 EDT
Message-ID: <5396C848.8020701@pcserviceselectronics.co.uk>
Date: Tue, 10 Jun 2014 09:56:40 +0100
From: Paul Carpenter <paul@pcserviceselectronics.co.uk>
Organization: PC Services (Reading)
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RESEND2 PATCH v4 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire
 Interface) controller support
References: <1401785392-26602-1-git-send-email-boris.brezillon@free-electrons.com> <1401785392-26602-3-git-send-email-boris.brezillon@free-electrons.com> <20140610083850.GB2620@katana>
In-Reply-To: <20140610083850.GB2620@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> On Tue, Jun 03, 2014 at 10:49:52AM +0200, Boris BREZILLON wrote:
>> The P2WI looks like an SMBus controller which only supports byte data
>> transfers. But, it differs from standard SMBus protocol on several
>> aspects:
>> - it supports only one slave device, and thus drop the address field
>> - it adds a parity bit every 8bits of data
>> - only one read access is required to read a byte (instead of a read
>>   followed by a write access in standard SMBus protocol)

Minor quibble should be
"(instead of a write followed by a read access in standard SMBus
   protocol)"

That being similar to EEPROM and other types of devices write internal
address followed by read access from internal address.

>> - there's no Ack bit after each byte transfer
>>
>> This means this bus cannot be used to interface with standard SMBus
>> devices (the only known device to support this interface is the AXP221
>> PMIC).
> 
> Good description. Should be a comment at the top of the driver to spread
> the word.

-- 
Paul Carpenter          | paul@pcserviceselectronics.co.uk
<http://www.pcserviceselectronics.co.uk/>    PC Services
<http://www.pcserviceselectronics.co.uk/pi/>  Raspberry Pi Add-ons
<http://www.pcserviceselectronics.co.uk/fonts/> Timing Diagram Font
<http://www.badweb.org.uk/> For those web sites you hate
