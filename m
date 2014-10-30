Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbaJ3VzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:55:07 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52526 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3VzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:55:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        jingchang.lu@freescale.com, gregory.0xf0@gmail.com
Subject: Re: [PATCH] serial: of-serial: zero-out struct of_serial_info
Date: Thu, 30 Oct 2014 22:55 +0100
Message-ID: <5481851.EJfv4DSzbT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414703913-1343-1-git-send-email-f.fainelli@gmail.com>
References: <1414703913-1343-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9g+JPkvXKCW0fhwbnbjjVPjga/n9A6E0H/w5tdSTdnJ
 hfV31HpZkqjZ3rSY3Dmq3QfTmZUDdhsIZo9cYlmlLWA8wOM0mp
 Or4J5lMvuDMEPi+/VHQAmwvK3nrdq5jpdQ14fRAJ5sm0wEBviN
 jlIiy5Lv0zYuzTJbl6CtaPPbjPE5erWGiXXfXjot8TlWOWuuo4
 Zcly4RvDTFhz7vHcNQvQS0iPseLbX4T0lutgWOWsAgCQqzjI83
 U6fqkneGqSwksbwssT1fI5hmdlMIiKoWGEeomgfrw7qdF/Yd59
 m9V6Wd05t+34bbirKPCjag1RF3PANhALWIc6gY+PTn/fflFogZ
 x/bVTECv3MJ+yyZsytII=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 14:18:33 Florian Fainelli wrote:
> of_platform_serial_probe() invokes of_platform_serial_setup() with a
> kmalloc'd struct of_serial_info cookie, which is not much of a problem
> for most of the struct of_serial_info fields we access but info->clk.
> 
> On platforms which do not provide a clock phandle for their UART nodes
> but do provide a 'clock-frequency' property, we basically leave the
> info->clk variable uninitialized, and this craps out during
> suspend/resume with oopses, crashes or warnings in the clock code.
> 
> Fix this by using kzalloc() which also zeroes-out the structure and
> provides an initialized info->clk member set to NULL.
> 
> Fixes: 2dea53bf57783 ("serial: of-serial: add PM suspend/resume support")
> Fixes: e34b9c94b6e8d ("[POWERPC] of_serial: add port type checking")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 

I thought I'd acked this patch before, maybe someone else sent the same
one. This is definitely required, so

Acked-by: Arnd Bergmann <arnd@arndb.de>
