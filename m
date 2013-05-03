Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763723Ab3ECV05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:26:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763482Ab3ECV04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:26:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH, RFC 14/22] oprofile: always enable IRQ_WORK
Date: Fri, 3 May 2013 23:26:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Robert Richter <rric@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, oprofile-list@lists.sf.net
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <20130503115332.GT8356@rric.localhost> <1367594095.7373.14.camel@gandalf.local.home>
In-Reply-To: <1367594095.7373.14.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305032326.23973.arnd@arndb.de>
X-Provags-ID: V02:K0:cfbQUDI9q3KcW6N3lzM44aaW8FRnie7B75c/E9LZYvd
 RFzHLLKPqI8EI3OjM4lpEp3vs4P3mhvBPjI3eGJslAAd7vOekJ
 lUgfZnDgzPS5pvJaT6XSrTav+dPc9A1sRowKywCvmojLtsBohH
 4QmKT0o+9u7lORZp2buFpNgwsngQq6HOel1H5CXrTHkOSr4H8Q
 nH1iD4cr6KOST69tPXL5HHOJM2/8nqOpGMxoqtAtz187HO34vM
 o0uN0/l6q1LHX+E3g/IelpTgp1yHanxO2jM1VXvHwdN9Ff24lx
 jEEBae3+3+uHuJfcTCriwdiDYE1ycTvaLk6FvUE7vxcmPCfUjJ
 45HBIASpYYogl//bSZx4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 May 2013, Steven Rostedt wrote:
> On Fri, 2013-05-03 at 13:53 +0200, Robert Richter wrote:
> > On 02.05.13 17:16:18, Arnd Bergmann wrote:
> > > oprofile fails to build if CONFIG_IRQ_WORK is not already enabled,
> > > because of the dependency on the RING_BUFFER code that now uses
> > > the irq work library.
> > > 
> > > kernel/built-in.o: In function `ring_buffer_unlock_commit':
> > > :(.text+0x5b8f0): undefined reference to `irq_work_queue'
> > > kernel/built-in.o: In function `ring_buffer_write':
> > > :(.text+0x5bd10): undefined reference to `irq_work_queue'
> > 
> > Shouldn't this be fixed in the ring_buffer implementation?
> 
> Does this patch fix it?
> 


Yes, this works, and looks much nicer than my version. Thanks!

	Arnd
