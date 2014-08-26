Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbaHZJmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:42:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49901 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934302AbaHZJmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:42:45 -0400
Message-ID: <53FC566C.30904@ahsoftware.de>
Date: Tue, 26 Aug 2014 11:42:04 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Jon Loeliger <jdl@jdl.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo>
In-Reply-To: <20140826084922.GG17263@ulmo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 10:49, schrieb Thierry Reding:
> On Tue, Aug 26, 2014 at 09:42:08AM +0100, Grant Likely wrote:
>> On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
> [...]
>>> There are somewhat standardized bindings for the above and especially
>>> for bindings of the type that clocks implement this is trivial. We can
>>> simply iterate over each (phandle, specifier) tuple and check that the
>>> corresponding clock provider can be resolved (which typically means that
>>> it's been registered with the common clock framework).
>>>
>>> For regulators (and regulator-like bindings) the problem is somewhat
>>> more difficult because they property names are not standardized. One way
>>> to solve this would be to look for property names with a -supply suffix,
>>> but that could obviously lead to false positives. One alternative that I
>>> think could eliminate this would be to explicitly list dependencies in
>>> drivers. This would allow core code to step through such a list and
>>> resolve the (phandle, specifier) tuples.
>>
>> False positives and negatives may not actually be a problem. It is
>> suboptimal, certainly, but it shouldn't outright break the kernel.
>
> There could be cases where some random integer in a cell could be
> interpreted as a phandle and resolve to a struct device_node. I suppose
> it might be unlikely, but not impossible, that the device_node could
> even match a device in the correct subsystem and you'd get a wrong
> dependency. Granted, a wrong dependency may not be catastrophic in that
> it won't lead to a crash, but it could lead to various kinds of
> weirdness and hard to diagnose problems.

You need either the type information in the DTB (that's why I've add 
those "dependencies" to identify phandles), or you need to know every 
binding (at "dependency-resolve-time" to identify phandles. The latter 
is impracticable to implement in a generic way (for use with every 
possible binding).

Regards,

Alexander Holler

