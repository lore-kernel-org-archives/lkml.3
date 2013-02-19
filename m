Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab3BSQup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:50:45 -0500
Received: from ud03.udmedia.de ([194.117.254.43]:48946 "EHLO
	mail.ud03.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3BSQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:50:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 19 Feb 2013 17:44:01 +0100
From: =?UTF-8?Q?Dieter_N=C3=BCtzel?= <dieter@nuetzel-hh.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: =?UTF-8?Q?Anja_N=C3=BCtzel?= <Anja@nuetzel-hh.de>,
        Alan Stern <stern@rowland.harvard.edu>, Jeff Mahoney <jeffm@suse.com>,
        <mmarek@suse.cz>,
        =?UTF-8?Q?Dieter_N=C3=BCtzel?= <Dieter@nuetzel-hh.de>,
        stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] openSUSE 12.2 stable kernel 3.7.8-1 big USB 2.0
 slowdown
Organization: DN
In-Reply-To: <512342F8.5060200@suse.cz>
References: <Pine.LNX.4.44L0.1302182155510.12532-100000@netrider.rowland.org>
 <512342F8.5060200@suse.cz>
Message-ID: <c4dc6832f4c82adb3a87a3a42c5e67d6@mail.ud03.udmedia.de>
User-Agent: Roundcube Webmail/0.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-02-19 10:16, schrieb Jiri Slaby:
> On 02/19/2013 03:56 AM, Alan Stern wrote:
>> On Mon, 18 Feb 2013, Jiri Slaby wrote:
>>
>>> On 02/18/2013 06:25 AM, Anja Nützel wrote:
>>>> Maybe it startet with 3.7.7.
>>>> I could copy several MB onto my USB 2.0 sticks with 3.7.6. (I 
>>>> think).
>>>> Even with full speed.
>>>>
>>>> With openSUSE 12.2 DVD (kernel 3.4.x) it works OK, too.
>>>>
>>>> Now it degrates to 12 mbits (full-speed USB only).
>>>
>>> This is an upstream 3.7.7 stable regression, I think. Some of these
>>> patches perhaps:
>>> d7da098 USB: EHCI: fix for leaking isochronous data
>>> caa891a USB: storage: optimize to match the Huawei USB storage 
>>> devices
>>> and support new switch command
>>> 08b4bfd USB: storage: Define a new macro for USB storage match 
>>> rules
>>> 390077b usb: Using correct way to clear usb3.0 device's remote 
>>> wakeup
>>> feature.
>>> 93dffb7 USB: EHCI: fix bug in scheduling periodic split transfers
>>> bf79379 USB: EHCI: fix timer bug affecting port resume
>>> d01875f USB: EHCI: unlink one async QH at a time
>>> 269ef9f USB: EHCI: remove ASS/PSS polling timeout
>>>
>>> Alan, any ideas?
>>
>> A lot of people have reported problems caused by the last one
>> (269ef9f).  I haven't had time to investigate yet (just got back 
>> from
>> vacation).
>
> I reverted that one in:
> http://labs.suse.cz/jslaby/bug-804367/
>
> Anja, could you test that kernel?

"Anja's" kernel (your kernel-desktop-3.7.9-0.i686.rpm) works OK!

openSUSE stable (kernel-desktop-3.7.9-1.1) of course NOT.

Only little thing KDE-Infozentrum Version 4.10.00 "release 547" Unter 
KDE 4.10.00 "release 550" do not show all USB devices correctly.

Sonja /Pakete# lsusb -t
4-1:1.0: No such file or directory
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
     |__ Port 1: Dev 2, If 0, Class=vend., Driver=, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
     |__ Port 2: Dev 5, If 0, Class=stor., Driver=usb-storage, 480M
     |__ Port 3: Dev 4, If 0, Class=stor., Driver=usb-storage, 480M
     |__ Port 8: Dev 3, If 0, Class=stor., Driver=usb-storage, 480M

Sonja /Pakete# lsusb
Bus 001 Device 005: ID 0951:1607 Kingston Technology DataTraveler 100
Bus 001 Device 004: ID 058f:6387 Alcor Micro Corp. Transcend JetFlash 
Flash Drive
Bus 001 Device 003: ID 058f:6362 Alcor Micro Corp. Flash Card 
Reader/Writer
Bus 004 Device 002: ID 04a9:220d Canon, Inc. CanoScan N670U/N676U/LiDE 
20
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Thank very much!

Anja & Dieter
