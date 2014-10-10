Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaJJTm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:42:28 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57961 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaJJTm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:42:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Date: Fri, 10 Oct 2014 21:42:21 +0200
Message-ID: <2769473.KEN6DZKnT7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141010182604.GC6075@katana>
References: <20141010072439.GA1741@katana> <20141010083627.GL5182@n2100.arm.linux.org.uk> <20141010182604.GC6075@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pu5tzLrr4qYg6fmRxJIo9ukHzmW7+oMbBS63dkdp4iv
 EKKAF6ooGe6qgjfP8iWgNwu2+lvUhEpgMOMsDDhLzmuSbaKwcd
 ZwdD/tlLdzrbqK3LOlKMiGdLclzMV9wpZwtWpMtCnMtICXL7RA
 YZjdSB4khBrgsHMJx5v3/dPHBhnfMN3s9gDp9SZYyGjQByrvxr
 NyYYR1sXSe5+eAVwEpfyPFekROz05JBAZDJ8h1LSiP3cTB08lM
 i3oizJUPmCTCo4AIJJYc5O2sfm15xs0KXnb+1LawSCQoNsAN8r
 RGoGALKsNiqy68pyQkYrw4+nscRoqVZVDitcrb/g7RmUoEzPMC
 q27iJmqJmR5V76PjE5mM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 20:26:05 Wolfram Sang wrote:
> 
> You got me wondering, though, that it could not be correct to call
> platform_driver_register() from the platform core instead of module
> init. I will check tomorrow. Still, this would be a bug independent of
> my series. Although I'd need to respin it if platform_driver_probe()
> needed a fix.

Right, this seems to be a preexisting bug. platform_create_bundle 
and platform_driver_probe will both overwrite the .owner field with
NULL since they live in builtin code. They need to be replaced with
__platform_driver_probe and __platform_driver_register that both
take an extra owner argument passed down from the caller in the driver
module.

	Arnd
