Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaHZKTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:19:03 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51270 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaHZKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:19:00 -0400
Message-ID: <53FC5EFB.6020109@ahsoftware.de>
Date: Tue, 26 Aug 2014 12:18:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<20140514141914.446F7C4153D@trevor.secretlab.ca>	<20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de>	<20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo>	<E1XLu15-0002DP-6o@jdl.com> <20140826085128.958A9C40989@trevor.secretlab.ca>
In-Reply-To: <20140826085128.958A9C40989@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 10:51, schrieb Grant Likely:

> Getting the dependency tree I think is only half the problem. The other
> have is how to get the driver model to actually order probing using that
> list. That problem is hard because the order drivers are probed is
> currently determined by the interaction of driver link order, driver
> initcall level, and device registration order. The first devices are
 > registered at an early initcall, before their drivers, and therefore
 > bind order is primarily determined by initcall level and driver link
 > order. However, later devices (ie. i2c clients) are registered by the
 > bus driver (ie. again, i2c) and probe order may be primarily link order
 > (if the driver is not yet registered) or registration order (if the
 > driver was registered before the parent bus).

Using my patches, the problem which still exists is how to handle 
devices (not drivers). I've build the patches based on the assumption 
that device-handling happens automatically. Unfortunately that isn't 
really true and device-handling looks awkward. Some drivers build them 
themself, some require that a device already exists and some require 
that a device doesn't already exist.

But I haven't looked in deep at that. I'm sure that can be fixed by 
fixing drivers which do things differently than they should (maybe 
because they needed to do such for dirty workarounds because no order 
was guaranteed, which wouldn't be true anymore).

Anyway, I've not looked further into that problem (with devices, not 
drivers) as it already seems quiet impossible to get the other necessary 
stuff into the kernel in a reasonable time (before 32bit-HW which does 
use DT will not be available anymore).

Regards,

Alexander Holler
