Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaEJMcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:32:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51489 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaEJMcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:32:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536E1C4D.9030206@roeck-us.net>
Date: Sat, 10 May 2014 05:32:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andreas Werner <wernerandy@gmx.de>, linux-kernel@vger.kernel.org
CC: khali@linux-fr.org, andreas.werner@men.de
Subject: Re: Question: hwmon: Adding addtitional sysfs entries
References: <20140510132238.GA28364@awedesk.fritz.box>
In-Reply-To: <20140510132238.GA28364@awedesk.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 06:22 AM, Andreas Werner wrote:
> Hi,
> i am currently working on an implemenation of my Board Management Controller (BMC).
>
> This Controller is a MCR assembled on almost all of our Compact PCI or Compact PCI Serial
> Cards as well as on some other CPU Boards.
>
> The BMC includes LED´s, Watchdog, Voltage Monitoring and some other features.
> I have already implemented an MFD driver, LED and Watchdog driver.
>
> Currently i am working on the hwmon implemenation. This includes for the first step the
> voltage monitoring.
>
> The BMC has some other feature which are not supported by any of the subsystem.
>   - Errorcounter (Board status)
>   - Power Failure status
>   - Operating ours

Guess you mean hours here.

>   - Do software reset, do cold reset
>   - Set power modes
>   - Backplate Geographical Address
>
> These are all informations related to the Board where the BMC is assembled to.
> I think all those features could be part of the hwmon implementation.
>
Why ?

> Is it possible to add "custom" sysfs entries in my hwmon driver to support all these features?
> Does lm-sensor ingore those custom features or is it a problem for lm-sensors?
>
> What is the normal way to add those features?
>

The hwmon subsystem isn't really the correct location for this functionality.
Power management should be done with a regulator driver (possibly power).
The other attributes and functionality would better fit into the mfd core
driver.

You might want to tie the reset functions into the system reset functionality.

Guenter

