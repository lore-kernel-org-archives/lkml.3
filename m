Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaJWSru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:47:50 -0400
Received: from mail.imsco-us.com ([69.178.150.47]:43573 "EHLO ImsEx1.ims.dom"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932321AbaJWSrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:47:49 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 14:47:48 EDT
From: Chris Healy <chealy@imsco-us.com>
To: Guenter Roeck <linux@roeck-us.net>, Andrew Lunn <andrew@lunn.ch>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM
 	accessfunctions
Thread-Topic: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM
 	accessfunctions
Thread-Index: AQHP7uAMX9Wa0xyc10OITY9LmlueXJw+A/uF
Date: Thu, 23 Oct 2014 18:41:59 +0000
Message-ID: <724F6C6CDC8C86478473775085778C4E0A465931@ImsEx1.ims.dom>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net><141403700
	2-25528-11-git-send-email-linux@roeck-us.net><20141023135412.GC25190@lunn.ch>,<20141023164052.GB21343@roeck-us.net>
In-Reply-To: <20141023164052.GB21343@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.3.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

I do not believe it is possible to know if an EEPROM is attached or not.

Chris
________________________________________
From: Guenter Roeck [linux@roeck-us.net]
Sent: Thursday, October 23, 2014 9:40 AM
To: Andrew Lunn
Cc: netdev@vger.kernel.org; David S. Miller; Florian Fainelli; linux-kernel@vger.kernel.org; Chris Healy
Subject: Re: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM         accessfunctions

On Thu, Oct 23, 2014 at 03:54:12PM +0200, Andrew Lunn wrote:
> On Wed, Oct 22, 2014 at 09:03:18PM -0700, Guenter Roeck wrote:
> > MV88E6352 supports read and write access to its configuration eeprom.
>
> Hi Guenter
>
> I don't have the datasheet for the MV88E6352. Is the EEPROM built in,
> or external on an i2c bus?
>
External.

> > +static int mv88e6352_get_eeprom_len(struct dsa_switch *ds)
> > +{
> > +   return 0x200;
> > +}
>
> How do you handle the case of it being external and not populated.
> Would it not be better to try to detect it here, and return 0 if it
> does not exist?
>
Makes sense, if it is detectable that it the EEPROM not there. Browsing
through the datasheet, I don't see how I could detect it; there does not
seem to be a status bit indicating if the EEPROM is there or not. There
are sw_mode pins which determine if the eeprom should be loaded after
reset or not, but I don't see anything in the register set which would
tell me.

Chris, do you know if there is a means to detect if the EEPROM is present
on the MV88E6352 ?

Thanks,
Guenter

________________________________


This email and any files transmitted with it are confidential & proprietary to Systems and Software Enterprises, LLC. This information is intended solely for the use of the individual or entity to which it is addressed. Access or transmittal of the information contained in this e-mail, in full or in part, to any other organization or persons is not authorized.
