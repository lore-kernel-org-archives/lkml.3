Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaIYKoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:44:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50579 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaIYKoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
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
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 01/17] asm-generic: io: implement relaxed accessor macros as conditional wrappers
Date: Thu, 25 Sep 2014 12:43:41 +0200
Message-ID: <14780144.KRcmhp8YbE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140925103846.GI20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <4501051.vdxhyhkTWv@wuerfel> <20140925103846.GI20043@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yXKZ3Ukp3vjgtRxccMNqUtwCQHu7POrBGAEKEWQZ0ny
 K5kkYMvjZnkuFvjk3GzXuhqQT+JwSvMab132HyxbImtZRInBiv
 u7SXgDGAa56aiCeR+EXp5z/kKekmf0LviB1p4HDF1lhGbeCohD
 fbFPc67RdwTSMbmOD4pPZQ2GGxk8pcPQpCFFCVahoXAV09oSzu
 SE1CkF/XQs9naTL29lfBX7z76IkQGKlzpRKWIA2kym352DVRO4
 D7F/eZeUewPEEkFsl393wsiP0a0lO4ZfQQJzHt4j4wtnfmRkYy
 eVPUQluxq93GNjDrKQI4zCd9CCNfIrdQtgaG0Fuyg2xYQvUQho
 cT7plLOJuLHPgTpJUdKE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 11:38:46 Will Deacon wrote:
> On Thu, Sep 25, 2014 at 11:32:00AM +0100, Arnd Bergmann wrote:
> > On Wednesday 24 September 2014 18:17:20 Will Deacon wrote:
> > > {read,write}{b,w,l,q}_relaxed are implemented by some architectures in
> > > order to permit memory-mapped I/O accesses with weaker barrier semantics
> > > than the non-relaxed variants.
> > > 
> > > This patch adds wrappers to asm-generic so that drivers can rely on the
> > > relaxed accessors being available, even if they don't always provide
> > > weaker ordering guarantees. Since some architectures both include
> > > asm-generic/io.h and define some relaxed accessors, the definitions here
> > > are conditional for the time being.
> > > 
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > ---
> > >  include/asm-generic/io.h | 26 ++++++++++++++++++++++++++
> > >  1 file changed, 26 insertions(+)
> > > 
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks, Arnd. Do you have other patches queued for asm-generic, or shall I
> take this patch (on its own) via the arm64 tree?

I don't have other patches queued up yet, but Thierry has another patch
for asm-generic/io.h that I want to merge, so this time I'd prefer to
take it through my tree in case there are conflicts.

	Arnd
