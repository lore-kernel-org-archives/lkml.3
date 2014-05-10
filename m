Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaEJOC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:02:29 -0400
Received: from mout.gmx.net ([212.227.15.15]:55105 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaEJOC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:02:28 -0400
Date: Sat, 10 May 2014 18:02:17 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, andreas.werner@men.de
Subject: Re: Question: hwmon: Adding addtitional sysfs entries
Message-ID: <20140510160217.GA775@awedesk.fritz.box>
References: <20140510132238.GA28364@awedesk.fritz.box>
 <536E1C4D.9030206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <536E1C4D.9030206@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:3Ma6TLlI2a8MG3ZWG8ZSj2G4nrLhJP7oi6xhDe89tlO/JZfYABM
 TNB/JHjB7pk1NYuTfTs/0lGyaplbh0Ug4qy0Qogb8kR24jMjoyRIG/nU7dleP19xuOKoTAS
 DpPQvSaMibgqsAdqqi0g4eLMUcg4gQi6lKIKSaS949P1hwPohVBQyvKfn1k4GRRaxU/Q9Oa
 9HvCMHhDsx8viW1qlTEjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 05:32:13AM -0700, Guenter Roeck wrote:
> On 05/10/2014 06:22 AM, Andreas Werner wrote:
> >Hi,
> >i am currently working on an implemenation of my Board Management Controller (BMC).
> >
> >This Controller is a MCR assembled on almost all of our Compact PCI or Compact PCI Serial
> >Cards as well as on some other CPU Boards.
> >
> >The BMC includes LED´s, Watchdog, Voltage Monitoring and some other features.
> >I have already implemented an MFD driver, LED and Watchdog driver.
> >
> >Currently i am working on the hwmon implemenation. This includes for the first step the
> >voltage monitoring.
> >
> >The BMC has some other feature which are not supported by any of the subsystem.
> >  - Errorcounter (Board status)
> >  - Power Failure status
> >  - Operating ours
> 
> Guess you mean hours here.

Yes sorry my mistake.

> 
> >  - Do software reset, do cold reset
> >  - Set power modes
> >  - Backplate Geographical Address
> >
> >These are all informations related to the Board where the BMC is assembled to.
> >I think all those features could be part of the hwmon implementation.
> >
> Why ?

As all of the settings are CPU board related i thought it will be an good idea
to put as much settings as possible to a group to one subsystem.
This would be easier for the User Application.

> 
> >Is it possible to add "custom" sysfs entries in my hwmon driver to support all these features?
> >Does lm-sensor ingore those custom features or is it a problem for lm-sensors?
> >
> >What is the normal way to add those features?
> >
> 
> The hwmon subsystem isn't really the correct location for this functionality.
> Power management should be done with a regulator driver (possibly power).
> The other attributes and functionality would better fit into the mfd core
> driver.
> 

MFD Core sounds good. That is also perfect for the User App. 

> You might want to tie the reset functions into the system reset functionality.

I do not understand this. Is there another subsystem or something like that
were I can put the Reset stuff to?

> 
> Guenter
> 


I guess the hwmon subsys is the right place for the voltage monitoring (3,3V, 5V etc) isn´t it?


Regards Andy
