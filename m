Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbaJUUHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:07:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45896 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbaJUUHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:07:35 -0400
Message-ID: <5446BCEB.3020708@ti.com>
Date: Tue, 21 Oct 2014 15:07:07 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Tony Lindgren <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "Franklin Cooper Jr." <fcooper@ti.com>
Subject: Re: [PATCH] ARM: dts: DRA7: Add aliases for all serial ports
References: <1413908295-699-1-git-send-email-nm@ti.com> <3461773.MMIsJQMVIu@wuerfel>
In-Reply-To: <3461773.MMIsJQMVIu@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 02:57 PM, Arnd Bergmann wrote:
> On Tuesday 21 October 2014 11:18:15 Nishanth Menon wrote:
>> Add serial port aliases for consoles > 6.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7.dtsi |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index 9cc9843..208dd83 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -34,6 +34,10 @@
>>                 serial3 = &uart4;
>>                 serial4 = &uart5;
>>                 serial5 = &uart6;
>> +               serial6 = &uart7;
>> +               serial7 = &uart8;
>> +               serial8 = &uart9;
>> +               serial9 = &uart10;
>>
> 
> I think this was wrong to start with: The aliases should be in the per-board
> .dts file and only list the ones that are actually connected to the outside.
> 
> Otherwise the numbering won't match what's written on the board.

At least in the case of DRA7 boards, they are not written specifically
since they come out over onboard FTDI usb2serial.

This will at least ensure that /dev/ttyO9 will always point to uart10
no matter the board, instead of having ttyO0 always pointing to
console serial port no matter the board (and having to guess which
figure out it actually was aliased to).

-- 
Regards,
Nishanth Menon
