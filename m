Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3ARTZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:25:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3ARTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:25:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 31/76] ARC: Build system: Makefiles, Kconfig, Linker script
Date: Fri, 18 Jan 2013 19:25:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-32-git-send-email-vgupta@synopsys.com> <20130118190452.GA14433@merkur.ravnborg.org>
In-Reply-To: <20130118190452.GA14433@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181925.36466.arnd@arndb.de>
X-Provags-ID: V02:K0:4+WcuenntnxCFarjqt0Bsu7PSttTn3OzVhlE7YDxVsR
 zKVQZ5mOEJN+f4KL6TrlEKLH+m1EwMAkcUIdCabbmo0rxABtfJ
 BYKWyXzeslBRJInVJ8oNLZrWEalz2eFpy9sqVojifsJT7xCPjw
 ZfCn89ODUNvcdkmHfNCrzCgQSgigVU+XKVCgUuEqdWO406JIYx
 S03+RZKovSm+MtwHdKNQ56qKSv3cmcmHT0rU/QCgeBkVxO92We
 wYTmFaVW21TNuZmPERArk3iDN1sQnsxC5KUqhlUxgnXY4tB7X0
 F1f6QYUAhoiE3DFV5TCDuBXjDWll3YlRfLpdRXsBoKWJ6XMTJc
 s1bHRfBxSgJi1S7t97Wc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Sam Ravnborg wrote:
> > +obj-y        := arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
> > +        signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
> 
> For new stuff I usually recommend to drop line continuation using \
> 
> Just do the much prettier:
> obj-y := arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
> obj-y += signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o

Agreed, although we are moving some files to the more verbose

obj-y += arcksyms.o
obj-y += clk.o
obj-y += entry.o
obj-y += ...

and use alphabetical order, both of which help avoid merge conflicts
when Makefile changes come in through separate branches. This 
particular Makefile is likely to remain rather stable though, so
it's not necessary to go this far.

	Arnd
