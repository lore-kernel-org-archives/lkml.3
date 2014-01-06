Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaAFJXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:23:25 -0500
Received: from canardo.mork.no ([148.122.252.1]:36902 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaAFJXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:23:22 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: hayeswang <hayeswang@realtek.com>
Cc: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
Organization: m
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com>
	<1388633110-1435-1-git-send-email-hayeswang@realtek.com>
	<877gai8nqu.fsf@nemi.mork.no>
	<605671F106F540BA9665A195CACB78A0@realtek.com.tw>
	<8738l58pyd.fsf@nemi.mork.no>
	<AA7EB9EA13B74B14BBE08C4278F7948C@realtek.com.tw>
Date: Mon, 06 Jan 2014 10:21:56 +0100
In-Reply-To: <AA7EB9EA13B74B14BBE08C4278F7948C@realtek.com.tw>
	(hayeswang@realtek.com's message of "Mon, 6 Jan 2014 11:20:43 +0800")
Message-ID: <87eh4l31or.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> writes:
>  Bjørn Mork [mailto:bjorn@mork.no] 
> [...]
>> Sorry, but then this makes even less sense.  The active USB
>> configuration is user selectable and you should make any of 
>> them work if
>> possible.  Why can't the drivers figure out this at runtime?
>
> Excuse me. I have no idea about how to switch the configuration at
> the runtime ,and how to change the default configuration when a
> USB device is plugged. When a user select one of the configurations,
> he/she would wish to fix the configuration number after rebooting or
> after the dangle is unplugged and plugged again. For these reasons,
> this is the simple way which I could think. Maybe I choose the wrong
> method because I don't know how to satisfy the requests. May you
> provide me the relative information? Then, I could replace the current
> method. Thanks.

I apologise if I misunderstood you.  When you mentioned multiple
configurations, then I assumed it was a device similar to this one
(partial output from /sys/kernel/debug/usb/devices):

T:  Bus=03 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  2
P:  Vendor=1199 ProdID=68a2 Rev= 0.06
S:  Manufacturer=Sierra Wireless, Incorporated
S:  Product=MC7710
S:  SerialNumber=358178040092316
C:  #Ifs= 6 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:  If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:  If#=19 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:  If#=20 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
C:* #Ifs= 2 Cfg#= 2 Atr=e0 MxPwr=  0mA
A:  FirstIf#=12 IfCount= 2 Cls=02(comm.) Sub=0e Prot=00
I:* If#=12 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
I:  If#=13 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:* If#=13 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms


Here you can see 2 configurations, where cfg #2 is active using a class
driver.  This is what Linux will choose in this case because the first
interface of cfg #1 is vendor specific.  But an end user can change it
by writing to the bConfigurationValue sysfs attribute:

 nemi:/tmp# echo 1 > /sys/bus/usb/devices/3-4/bConfigurationValue


giving this result:

T:  Bus=03 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  2
P:  Vendor=1199 ProdID=68a2 Rev= 0.06
S:  Manufacturer=Sierra Wireless, Incorporated
S:  Product=MC7710
S:  SerialNumber=358178040092316
C:* #Ifs= 6 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=qcserial
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=qcserial
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qcserial
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#=19 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
I:* If#=20 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms
C:  #Ifs= 2 Cfg#= 2 Atr=e0 MxPwr=  0mA
A:  FirstIf#=12 IfCount= 2 Cls=02(comm.) Sub=0e Prot=00
I:  If#=12 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0e Prot=00 Driver=
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
I:  If#=13 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=02 Driver=
I:  If#=13 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=4ms


Exactly the same device, but now cfg #1 is active and a different set of
drivers have bound to the interfaces.  This is possible because none of
the involved drivers disable the support for this device at build-time.
Instead they use the available interface descriptors for matching and
probing supported functions.

End users will of course normally not go around writing stuff to sysfs
attributes like this.  Creating an udev rule to select a specific
counfiguration when the device is plugged is more useful for normal
usage.

My point was that this sort of runtime configuration change should be
possible, assuming my understanding of the device layout is correct.
Which it isn't necessarily.  I don't have any such device and I haven't
seen any USB descriptor dump from one either.



Bjørn
