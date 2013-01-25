Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3AYInZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:43:25 -0500
Received: from sestofw01.enea.se ([192.36.1.252]:22881 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751441Ab3AYInW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:43:22 -0500
From: Mats Liljegren <mats.liljegren@enea.com>
To: Igor Grinberg <grinberg@compulab.co.il>,
        Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: RE: [BUG] panda board locks up on boot
Thread-Topic: [BUG] panda board locks up on boot
Thread-Index: AQHN+qjAni9YP6Nib0GW0m1VMtmgd5hZj/EAgAAj6PA=
Date: Fri, 25 Jan 2013 08:43:15 +0000
Message-ID: <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
References: <1359082886.21576.199.camel@gandalf.local.home>
 <51022FD2.8090101@compulab.co.il>
In-Reply-To: <51022FD2.8090101@compulab.co.il>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.140.47]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Do you have CONFIG_CPU_FREQ enabled? As I posted earlier in linux-kernel forum ("Failed booting PandaBoard ES with Linux 3.8 RC4" two days ago) my PandaBoard ES hangs while booting with this option enabled. It works fine without it. I have not bisected it down to a single commit though.

/Mats

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Igor Grinberg
Sent: den 25 januari 2013 08:10
To: Steven Rostedt
Cc: LKML; linux-arm-kernel; Tony Lindgren; Russell King; Venkatraman S
Subject: Re: [BUG] panda board locks up on boot

Hi Steven,

On 01/25/13 05:01, Steven Rostedt wrote:
> I've recently started testing my work on arm boards and have found 
> that they both don't boot under the latest kernel anymore. I already 
> posted about my snowball board, but my panda board also locks up.
> 
> I've bisected it down to this commit:
> 
> commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Fri Apr 13 12:27:37 2012 +0100
> 
>     mmc: omap_hsmmc: remove private DMA API implementation
>     
>     Remove the private DMA API implementation from omap_hsmmc, making it
>     use entirely the DMA engine API.
>     
>     Tested-by: Tony Lindgren <tony@atomide.com>
>     Tested-by: Venkatraman S <svenkatr@ti.com>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> 
> The commit before boots fine, when adding this commit, it locks up.
> 
> I reverted the commit (with tweaks) against 3.8-rc4 and was able to 
> get my board booting again. Not sure what to do, but I wanted to let 
> people know.

Care to post your kernel config file?


--
Regards,
Igor.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
