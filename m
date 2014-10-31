Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaJaWSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:18:31 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:58855
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbaJaWS3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:18:29 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
Thread-Topic: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
Thread-Index: AQHP9TLPK/O0QzpWPkODe23bN/ro9pxKgzsQgAC2MYD//4wE0A==
Date: Fri, 31 Oct 2014 22:18:28 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882601B051@P3PWEX4MB008.ex4.secureserver.net>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net>
 <5454086D.6000401@mev.co.uk>
In-Reply-To: <5454086D.6000401@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 3:09 PM, Ian Abbott wrote:
> On 31/10/14 18:19, Hartley Sweeten wrote:
>> On Friday, October 31, 2014 10:48 AM, Ian Abbott wrote:
>>> The Comedi core module doesn't need support for PCI, USB or PCMCIA.
>>> Only the low-level Comedi drivers need it.  Split the support for these
>>> bus types out of the core "comedi" module and into new modules,
>>> "comedi_pci", "comedi_usb", and "comedi_pcmcia".
>>>
>>> 1) staging: comedi: comedidev.h: remove dummy PCI support functions
>>> 2) staging: comedi: comedidev.h: remove some #ifdefs
>>> 3) staging: comedi: split out PCMCIA support into new module
>>> 4) staging: comedi: split out USB support into new module
>>> 5) staging: comedi: split out PCI support into new module
>>
>> Ian,
>>
>> Is this really necessary?
>>
>> The pci, usb, and pcmcia support is already conditionally compiled in.
>> The support does get added to the main comedi module instead of
>> as separate modules but that shouldn't be a problem.
>
> Well a lot of potentially unused module space could get pulled in if 
> using a stock distro kernel. For example, the USB dependencies amount to 
> over 200k. Not so bad for the others, especially PCI where the code is 
> built in anyway.

But its only pulled in if the user selected the usb, pci, and/or pcmcia
comedi drivers. And if they selected any of those options they will
need the that code anyway.

Splitting the bus specific code out of the comdi core module doesn't
lower the total module space used it just spreads it from one to possibly
four modules. And it increases the module dependancies for all the
usb, pci, and pcmcia comedi drivers.

To be clear, I'm not against this series I just want to make sure it's worth
applying.

Regards,
Hartley


