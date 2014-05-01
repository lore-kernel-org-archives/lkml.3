Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaEAS57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:57:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43667 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEAS55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:57:57 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: RE: [PATCH v1] serial: uart: add hw flow control support
 configuration
Thread-Topic: [PATCH v1] serial: uart: add hw flow control support
 configuration
Thread-Index: AQHPY/pnoO5UeURChk+XemJ6F+LdrJssFS9g
Date: Thu, 1 May 2014 18:57:18 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B70472A714@DFLE11.ent.ti.com>
References: <1398792122-18592-1-git-send-email-m-karicheri2@ti.com>
 <20140429222756.GA2382@flaeskesteg>
In-Reply-To: <20140429222756.GA2382@flaeskesteg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Mark Rutland [mailto:mark.rutland@arm.com]
>Sent: Tuesday, April 29, 2014 6:28 PM
>To: Karicheri, Muralidharan
>Cc: linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
>devicetree@vger.kernel.org; Rob Herring; Ian Campbell; Kumar Gala; Randy Dunlap; Greg
>Kroah-Hartman; Jiri Slaby; Shilimkar, Santosh
>Subject: Re: [PATCH v1] serial: uart: add hw flow control support configuration
>
>Hi,
>
>On Tue, Apr 29, 2014 at 06:22:02PM +0100, Murali Karicheri wrote:
>> 8250 uart driver currently supports only software assisted hw flow
>> control. The software assisted hw flow control maintains a hw_stopped
>> flag in the tty structure to stop and start transmission and use modem
>> status interrupt for the event to drive the handshake signals. This is
>> not needed if hw has flow control capabilities. This patch adds a DT
>> attribute for enabling hw flow control for a uart port. Also skip stop
>> and start if this flag is present in flag field of the port structure.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Pawel Moll <pawel.moll@arm.com>
>> CC: Mark Rutland <mark.rutland@arm.com>
>> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> CC: Kumar Gala <galak@codeaurora.org>
>> CC: Randy Dunlap <rdunlap@infradead.org>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: Jiri Slaby <jslaby@suse.cz>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  - Fixed brackets around port->flags & UPF_HARD_FLOW as per comments
>>  .../devicetree/bindings/serial/of-serial.txt       |    2 ++
>>  drivers/tty/serial/8250/8250_core.c                |    6 ++++--
>>  drivers/tty/serial/of_serial.c                     |    4 ++++
>>  drivers/tty/serial/serial_core.c                   |   12 +++++++++---
>>  4 files changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt
>> b/Documentation/devicetree/bindings/serial/of-serial.txt
>> index 1928a3e..123de01 100644
>> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
>> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
>> @@ -37,6 +37,8 @@ Optional properties:
>>  - auto-flow-control: one way to enable automatic flow control support. The
>>    driver is allowed to detect support for the capability even without this
>>    property.
>> +- hw-flow-control: this enables pure hw flow control and no software
>> +  intervention needed.
>
>From the wording of the commit message, I believe this would be better worded
>something like:
>
>- hw-flow-control: the hardware has flow control capability.
>
>While the OS needs to know that flow control is present if it wishes to make use of it,
>whether or not the OS does so is not a matter for the binding.
>
>It might also be better worded as "has-hw-flow-control", which would make that
>distinction clearer.
>
>Otherwise this looks fine to me.

Fine. Will re-send with rewording as

has-hw-flow-control: the hardware has flow control capability.

Murali
>
>Thanks,
>Mark.
