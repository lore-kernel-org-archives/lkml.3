Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3GCOsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:48:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56854 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3GCOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:48:44 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Jul 2013 07:48:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: Intel HWMON/NIC temperature sensor question
Message-ID: <20130703144845.GB10323@roeck-us.net>
References: <002401ce77e9$da6524b0$8f2f6e10$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002401ce77e9$da6524b0$8f2f6e10$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:35:50AM -0400, Justin Piszcz wrote:
> Hi,
> 
>  
> 
> I saw this in the device drive section and was curious which Intel-based
> NICs contain temperature sensors?
> 
>  
> 
> Intel(R) 10GbE PCI Express adapters HWMON support
> 
> Intel(R) PCI-Express Gigabit adapters HWMON support
> 
>  
> 
> I checked the boards below and none appear to expose a hwmon interface:
> 
> 08:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 
> 08:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 
> 08:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 
> 08:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network
> Connection (rev 01)
> 
> 09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> Connection
> 
> 0a:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> Connection
> 
> 01:00.0 Ethernet controller: Intel Corporation 82598EB 10-Gigabit AT2 Server
> Adapter (rev 01)
> 
82575 and 82599. Doesn't matter much, though, since they don't export the "name"
attribute from their driver, meaning the sensors command won't find the sensors.
Also, they enerate the hwmon device first and then create the attributes, which
is the wrong order and creates a potential race condition with demons.

Someone who has a board will have to fix that at some point.

Guenter
