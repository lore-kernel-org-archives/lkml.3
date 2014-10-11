Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaJKBon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 21:44:43 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44406 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaJKBol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 21:44:41 -0400
Message-ID: <54388B81.5020306@mentor.com>
Date: Fri, 10 Oct 2014 20:44:33 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <josh@joshtriplett.org>, Rabin Vincent <rabin@rab.in>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
References: <20140905213216.GD5001@linux.vnet.ibm.com> <20141008171322.GH22688@saruman> <20141008175707.GI22688@saruman> <20141008212938.GP22688@saruman> <20141009160138.GA2396@cmpxchg.org> <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk>
In-Reply-To: <20141010162531.GL12379@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
> 
> Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
> it seems that this has been known about for some time.)

Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
are affected, as well as 4.9.0.

> We can blacklist these GCC versions quite easily.  We already have GCC
> 3.3 blacklisted, and it's trivial to add others.  I would want to include
> some proper details about the bug, just like the other existing entries
> we already have in asm-offsets.c, where we name the functions that the
> compiler is known to break where appropriate.

Before blacklisting anything, it's worth considering that simple version
checks would break existing pre-4.8.3 compilers that have been patched
for PR58854.  It looks like Yocto and Buildroot issued releases with
patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
the most we can reasonably do without breaking some correctly-behaving
toolchains is to emit a warning.

Hopefully nobody's still using gcc 4.8 from the Linaro 2013.11 toolchain
release -- since it's a 4.8.3 prerelease from before the fix was
committed you'll get GCC_VERSION == 40803 but still generate bad code.

> However, I'm rather annoyed that there are people here who have known
> for some time that GCC 4.8.1 and GCC 4.8.2 _can_ lead to filesystem
> corruption, and have sat on their backsides doing nothing about getting
> it blacklisted for something like a year.

Mea culpa, although I hadn't drawn the connection to FS corruption
reports until now.  I have known about the issue for some time, but
figured the prevalence of the fix in downstream projects largely
mitigated the issue.

