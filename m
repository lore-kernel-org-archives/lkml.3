Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaI2Ju4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:50:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62423 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Juy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:50:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
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
Date: Mon, 29 Sep 2014 11:48:39 +0200
Message-ID: <6706376.rlHA7RUC15@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140929092510.GC20303@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <3359318.XmOCYLZHTV@wuerfel> <20140929092510.GC20303@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BNgdAKNugKC+4O4nqhaQGQXhfubJ4/DecvKIYgchyi5
 bipAyO7OCQy/E42dsZswPD3478my4Wu3ticmj1vtd2epk7Y68y
 0cdu5MN8DAYm2nGvChoBpInSi/kpzXpkYp57UtJJ+cuH830HV0
 owwFZbOWz8Vh2UhAHXYR9sA4SwYqssZ0YCbZimzfdK7SYvCJU3
 W7EOFS0B03xgW6g9vtKbOErZUwLevH/bTO2GAgr99BxcVIkYpA
 rNX7j+2d8mHGupEUJbwyGyRORgWP3X9TTPEQZ6+zzVzKgfN5ec
 e5sAQLsajohu4VLruMXpDAdCFQm1TnWrtkSApnMSojkU5SEkNw
 mNCKSI73eIfd0Es4JJWY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 10:25:10 Will Deacon wrote:
> On Fri, Sep 26, 2014 at 10:36:13PM +0100, Arnd Bergmann wrote:
> > On Friday 26 September 2014 14:46:08 Russell King - ARM Linux wrote:
> > > 
> > > Obviously, this does nothing for the:
> > > 
> > > include/asm-generic/io.h:804:29: error: redefinition of 'virt_to_bus'
> > > include/asm-generic/io.h:809:21: error: redefinition of 'bus_to_virt'
> > > 
> > > errors which are also reported in Olof's build system.
> > > 
> > > Given how close we are to the merge window, I'd suggest this stuff gets
> > > reverted so that it can have a better period of testing, rather than
> > > stuffing it into -next at such a critical time.
> > 
> > Right, I've fixed these all up locally, but then found new warnings on
> > allmodconfig builds that I haven't been able to track down yet.
> > 
> > I've dropped everything from the asm-generic tree now, so we can get
> > a clean linux-next tree.
> 
> Did you actually see any failures due to the relaxed I/O stuff, or was this
> all in the unrelated rework of the asm-generic/io.h file? If the latter, it
> would be a pity to postpone the former series.
> 

I believe all the problems I've seen were because of Thierry's series,
I haven't tried separating the two again yet, which is something I'd
probably try today.

However, I saw a lot of different problems with the combined series
and I have a patch to fix them up here, will post that once I see no
new regressions.

	Arnd
