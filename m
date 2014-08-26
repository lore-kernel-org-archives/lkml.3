Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaHZH5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:57:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:46509 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaHZH5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:57:05 -0400
Message-ID: <53FC3DBB.7000407@ahsoftware.de>
Date: Tue, 26 Aug 2014 09:56:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Loeliger <jdl@jdl.com>, Thierry Reding <thierry.reding@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com>
In-Reply-To: <E1XLu15-0002DP-6o@jdl.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.08.2014 15:08, schrieb Jon Loeliger:
>>
>
>> Anyway, instead of going back and forth between "deferred probe is good"
>> and "deferred probe is bad", how about we do something useful now and
>> concentrate on how to make use of the information we have in DT with the
>> goal to reduce the number of cases where deferred probing is required?
>
> Good idea.
>
> The proposal on the table is to allow the probe code
> to make a topological sort of the devices based on
> dependency information either implied, explicitly stated
> or both.  That is likely a fundamentally correct approach.
>
> I believe some of the issues that need to be resolved are:
>
>      1) What constitutes a dependency?

In my patches phandles are used. That works pretty good for almost all 
DTs. So almost all dependencies are already declared in a DT and almost 
no changes to the DT are necessary. The only binding I've seen where it 
doesn't work is remote-endpoint, because that binding isn't a directed 
dependency. So one of the two places where such a binding occurs needs a 
"no-dependencies = <phandle>" to avoid circular dependencies which can 
be solved.

>      2) How is that dependency expressed?

Already there in form of phandles.

>      3) How do we add missing dependencies?

My patches offer the possibility to extend or reduce the list of 
(automatically generated) dependencies by using "[no-]dependencies = < 
list of phandles >;"

>      4) Backward compatability problems.

None in my approach. The DT just includes an additional binding to 
circumvent the missing but needed type information for phandles.

Regards,

Alexander Holler
