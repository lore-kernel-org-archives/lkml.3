Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaHZKpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:45:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52224 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaHZKpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:45:05 -0400
Message-ID: <53FC6513.5040800@ahsoftware.de>
Date: Tue, 26 Aug 2014 12:44:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826102503.GC31124@ulmo>
In-Reply-To: <20140826102503.GC31124@ulmo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 12:25, schrieb Thierry Reding:
> On Tue, Aug 26, 2014 at 11:42:04AM +0200, Alexander Holler wrote:

>> You need either the type information in the DTB (that's why I've add those
>> "dependencies" to identify phandles), or you need to know every binding (at
>> "dependency-resolve-time" to identify phandles. The latter is impracticable
>> to implement in a generic way (for use with every possible binding).
>
> Like I already mentioned, this could be done in drivers who contain that
> information already anyway. Or parts of it could be done in subsystem-
> specific callbacks where a generic binding is available.

That would end up with almost the same ugly driver-based workarounds as 
now. It's much better if a driver author only has to define it's 
prerequisits (in form of dependencies in the dts) and could be sure the 
driver will only be probed if those are met, than to do that stuff based 
on a subsystem or even driver level.

If you add dependency-information to drivers, you have two problems:

- How do you get these information from the driver (remember, currently 
there is only one initial call, a initcall which might do almost anything)

- These information might become outdated and you would have to change 
all drivers. E.g. if the name of a dependency (driver) changes it 
wouldn't be done with changing the dts (maybe plural), but you would 
have to change the source of all dependant drivers too.

Regards,

Alexander Holler
