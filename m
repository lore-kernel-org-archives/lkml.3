Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab3EWQ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:26:18 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:40525 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab3EWQ0R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:26:17 -0400
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Thu, 23 May 2013 18:26:09 +0200
Subject: RE: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Topic: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Index: Ac5W/vSzitKA1jg1RYeGMTGEzopTSwA0AFNQ
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C3363440503@SAFEX1MAIL1.st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
 <A3BF01DB4A606149A4C20C4C4C808F6C336343F95B@SAFEX1MAIL1.st.com>
 <201305221713.37752.arnd@arndb.de>
In-Reply-To: <201305221713.37752.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 22 May 2013, Arnd Bergmann wrote:
> > Also all of the custom_divisor functionality is basically commented as "old"
> > or has a kernel warning saying it is deprecated (see uart_set_info), so as
> > far as I can see for our (and I suspect most) hardware it is completely
> > irrelevant functionality.
> 
> What may have happened here is that custom_divisor was used in a different
> way when I added that code than it is today, and the change was not propagated
> into the of_serial driver. However, going back to 2.6.20 shows no different
> code than what we have today in this regard. It may simply have been
> a mistake on my side.

Thanks for looking into this and digging around in the history. At least I didn't
miss something really obvious.

> I looked it up in the original serial port binding at
> http://www.openfirmware.org/1275/bindings/devices/html/serial.ht
> ml, which does
> not specify the property, and in ePAPR, which does have it in the
> section about
> "serial class devices":
> 
> 18 6.2.1.2 current-speed
> 19 Property: current-speed
> 20 Value type: <u32>
> 21 Description:
> 22 Specifies the current speed of a serial device in bits per second. A
> boot program should set
> 23 this property if it has initialized the serial device.
> 24 Example:
> 25 current - speed = <115200>; # 115200 baud
> 
> The reason you want this is so that the driver can initialize the hardware from
> scratch more easily and get back to the same settings. Why they only specified
> the baud rate but not also start/stop bits and flow control I don't understand
> though.

Yes, I had been made aware of the ePAPR definition by Srini after I sent the post.
In fact I had exactly the same question in my head about the other settings as
well.  

> 
> I guess you can ignore my original comment.
> 
OK.

Thanks again for your time.

Regards,
-stephen
