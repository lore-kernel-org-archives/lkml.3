Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIYKjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:39:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56723 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbaIYKjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:39:46 -0400
Date: Thu, 25 Sep 2014 11:38:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [PATCH v3 01/17] asm-generic: io: implement relaxed accessor
 macros as conditional wrappers
Message-ID: <20140925103846.GI20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <1411579056-16966-2-git-send-email-will.deacon@arm.com>
 <4501051.vdxhyhkTWv@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4501051.vdxhyhkTWv@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:32:00AM +0100, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 18:17:20 Will Deacon wrote:
> > {read,write}{b,w,l,q}_relaxed are implemented by some architectures in
> > order to permit memory-mapped I/O accesses with weaker barrier semantics
> > than the non-relaxed variants.
> > 
> > This patch adds wrappers to asm-generic so that drivers can rely on the
> > relaxed accessors being available, even if they don't always provide
> > weaker ordering guarantees. Since some architectures both include
> > asm-generic/io.h and define some relaxed accessors, the definitions here
> > are conditional for the time being.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  include/asm-generic/io.h | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks, Arnd. Do you have other patches queued for asm-generic, or shall I
take this patch (on its own) via the arm64 tree?

Will
