Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaJAShV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:37:21 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57807 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaJAShS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:37:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Wed, 01 Oct 2014 20:34:43 +0200
Message-ID: <2073993.PMCAKWXqHP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001152356.GA15818@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <2012641.4eaGXZM5vo@wuerfel> <20141001152356.GA15818@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5Tu1ICxZSG1D5unjHLeFyWtOOUcpy9EoB4qrD8pY00B
 bC/F8Yd5e4pQTL3kl+0bdT+eJMF1Zl0BXoQXhEwCPpImAGlQby
 f2RDGQwHfDH4fxtwYMJQm7bjT73V1ePrf703YBdUbRurNmD3Rd
 hadccxDX2Tibcv/5JtjpHScJxbpSZ4LoC/KGPJEVpsIVO/zIcF
 WgWe7T4u6/GOTwDDbZtfbxl+801YCvU6txbc/9O7C0gIH5wRpd
 6s/7pxwu00N+3fnqliYmBx4bJwrWuxPO77QdC6H4yhRJYM7+FR
 y3YqD7Z4MadCbBI3+NdPDiaUSMgiNITTPN3kf8Khvt0nFhFWH6
 Am7sfzDtvohGefoj7SBU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 17:23:58 Thierry Reding wrote:
> On Mon, Sep 29, 2014 at 11:50:13AM +0200, Arnd Bergmann wrote:
> > On Monday 29 September 2014 10:23:25 Thierry Reding wrote:
> > > 
> > > How about if I keep iterating this series? It seems like most failures
> > > can be reproduced by doing ARM defconfig and allmodconfig builds, so
> > > I'll do those and fix up any issues I find. Hopefully I can squash all
> > > these before 3.18-rc1, then we can take it into linux-next early for
> > > 3.19? In the meantime perhaps I can work with Olof to get a branch with
> > > these patches tested on his builder? And perhaps on the 0-day builder in
> > > addition?
> > 
> > Yes, definitely!
> > 
> > Note that I saw a lot of problems only in randconfig build tests but
> > not in any of the default configurations. I'll send you the fixup patch
> > soon so you can integrate that in your series.
> 
> One of the things I've seen a lot is warnings about volatile being
> ignored. This is caused by my latest series dropping the volatile
> keyword for the I/O accessors. The rationale being that use of volatile
> should be an implementation detail of the accessors rather than the
> function signature.

The reason those accessors have the volatile keyword in the argument
list is purely to silence the compiler when a driver passes a variable
that is marked volatile.

> Given the massive amount of changes needed to remove these warnings, is
> it better to just keep the volatile keyword even if it's clearly wrong
> in the context of the I/O accessors? Or should we bite the bullet and
> remove all the wrong uses while at it?
> 
> I suppose if we decide to remove them we can always make that a separate
> patch series.

Right, let's not do that now. We could put it on the kernel janitor wiki
as a task for newbies though.

	Arnd
