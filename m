Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBMSDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:03:05 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33480 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaBMSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:03:02 -0500
Message-ID: <52FD08D1.3030405@gmail.com>
Date: Thu, 13 Feb 2014 20:02:57 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: will.deacon@arm.com
CC: LKML <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since next-21012014 I started to receive "Received disconnect from 
x.x.x.x: 2: Bad packet length 3149594624" errors when trying to 
establish ssh session over wifi to my N900, running Maemo 5. I bisected 
and it turned out that commit dce5c9e35bc4085bd33eccdb8c9ec5a643507a14 
"ARM: 7928/1: kconfig: select HAVE_EFFICIENT_UNALIGNED_ACCESS for CPUv6+ 
&& MMU" is the first bad. There is nothing related in either dmesg or 
syslog on the device. Reverting that commit on 3.14-rc1 make those 
errors disappear.

As my knowledge on how to deal with that stops here, advises on what to 
do next to find the real problem are appreciated.

Ivo
