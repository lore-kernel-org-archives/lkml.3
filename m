Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3CPPIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:08:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:42165 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3CPPIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:08:44 -0400
Message-ID: <1363446518.12329.5.camel@localhost.localdomain>
Subject: Re: CONFIG_EARLY_PRINTK
From: Thomas Meyer <thomas@m3y3r.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 16:08:38 +0100
In-Reply-To: <5140D9DF.4010506@infradead.org>
References: <1363194921.1218.14.camel@localhost.localdomain>
	 <5140D9DF.4010506@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 13.03.2013, 12:56 -0700 schrieb Randy Dunlap:
> On 03/13/13 10:15, Thomas Meyer wrote:
> > Hi,
> > 
> >  -*- Early printk 
> > 
> > help text says:
> > "You should normally N here, unless you want to debug such a crash.
> > (Depends on: EXPERT [=n])"
> > 
> > How to normally N here?
> 
> You'll have to enable CONFIG_EXPERT and then you can disable EARLY_PRINTK.
> 
> You may even have to disable CONFIG_EMBEDDED before you can enable
> CONFIG_EXPERT (I did).
> 
> Too many hoops to have to jump through.   :(
> 

Yes,

so why not do this? As the text to EARLY_PRINTK explains?

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..d6c2d89 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -32,7 +32,7 @@ config X86_VERBOSE_BOOTUP
 
 config EARLY_PRINTK
        bool "Early printk" if EXPERT
-       default y
+       default n
        ---help---
          Write kernel log output directly into the VGA buffer or to a
serial
          port.



