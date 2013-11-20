Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3KTTer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:34:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3KTTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:34:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
Date: Wed, 20 Nov 2013 20:34:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>
References: <20131106110508.6806.48070.sendpatchset@w520> <201311141340.38208.arnd@arndb.de> <528D001C.9010009@linaro.org>
In-Reply-To: <528D001C.9010009@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311202034.34384.arnd@arndb.de>
X-Provags-ID: V02:K0:pPbnZc0SROSMIeZELnt7ptYPKVeGS/o+fqxVLHmJcal
 CeRqUxLkQn+wCn/ZdxxYlVt7dYCfJHyHpZqJ3OcS69vNM7vnk4
 syde2ePUkIb4bWOSYhYQJ19R4Ps2iENqRBjLZiW2djLZkhJN/G
 hWNDNS7UDowkGLw9ftP0JByckvYxkjLRwzJyOIc8Zx8IEnjKfE
 9HxnE4YOYRR5nL3/ojjOczbtrr/zPOy4WPmuRZaUWhqP/WzGDy
 wxFzhuY56dV7T+1PfF+3FNsFqDGzq7X978W+2cfs/tqTiuPCbB
 GncMVwYxE/pYzSUDAHUdKhxhr6hd9FVnIhJ2jvLhLeuKYhdstQ
 9fgWYDpLq9XVL4R08YMY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013, John Stultz wrote:
> On 11/14/2013 04:40 AM, Arnd Bergmann wrote:
> 
> Sorry, somehow this mail slipped by me.
> 
> So yea, as I mentioned earlier, the build testing is the one thing I
> don't have a good argument against. But I still would rather not having
> user prompts for these sorts of things.
> 
> Even so, it seems to me that it would be better to still avoid prompting
> the user for the build test and instead just always build the drivers if
> BUILD_TEST is enabled.
> 
> Is the driver by driver fine-granularity for build testing actually
> worth having all the module prompts?  Or could we coarsen it a bit, and
> have BUILT_TEST_TOPIC, so under kernel hacking or something you can
> enable build testing and select the categories of items you want to
> build (rather then having to go through them one by one?)

I would much prefer keeping things consistent across subsystems, which
means one symbol with prompt per driver. The only technical argument for
this is that it lets you disable some drivers when they do break in a
randconfig or allmodconfig build.

	Arnd
