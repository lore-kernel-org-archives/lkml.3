Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaJMJNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:13:33 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50917 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbaJMJN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:13:26 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Nathan Lynch'" <Nathan_Lynch@mentor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Sasha Levin" <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: RCU bug with v3.17-rc3 ?
Thread-Topic: RCU bug with v3.17-rc3 ?
Thread-Index: AQHP5PUYyBwqwCOmRU6/T6T+Bfea1ZwtwNIg
Date: Mon, 13 Oct 2014 09:11:34 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C996E@AcuExch.aculab.com>
References: <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman> <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman> <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian>
 <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman>
 <20141010135743.GB31348@saruman>
 <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com>
In-Reply-To: <54388B81.5020306@mentor.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch
> On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
> >
> > Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
> > it seems that this has been known about for some time.)
> 
> Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
> are affected, as well as 4.9.0.
> 
> > We can blacklist these GCC versions quite easily.  We already have GCC
> > 3.3 blacklisted, and it's trivial to add others.  I would want to include
> > some proper details about the bug, just like the other existing entries
> > we already have in asm-offsets.c, where we name the functions that the
> > compiler is known to break where appropriate.
> 
> Before blacklisting anything, it's worth considering that simple version
> checks would break existing pre-4.8.3 compilers that have been patched
> for PR58854.  It looks like Yocto and Buildroot issued releases with
> patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
> the most we can reasonably do without breaking some correctly-behaving
> toolchains is to emit a warning.

Is it possible to compile a small code fragment and check the generated
code for the bug?
Possibly predicated on the broken version number to avoid false positives.

	David



