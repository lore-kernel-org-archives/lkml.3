Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaIYPR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:17:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60712 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaIYPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:17:57 -0400
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
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Thu, 25 Sep 2014 17:15:14 +0200
Message-ID: <4240583.SJ4jiIW6Zy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3361270.4SkjDs5lox@wuerfel>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <20140925145538.GN20043@arm.com> <3361270.4SkjDs5lox@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UBQcWo5PBVEEup3rjthNQnQgJqNuqB7dFQ6y5jIALiZ
 UI9IHL/05xlocgJKO0xydgcNDind/WWy5kwehC0GKIOzysBap+
 gkekTDePeutOzPi1Q4HSd0zI10P6lgWgp7C70g6tm9PL9RE1BM
 YGdHlixquM0/qBY25uun1oo9AtyTQ+hLiw+hHJwlA2q9AH8RiR
 19GN/1LS7FVEcFASkx/SFu/XGqGHiy4y/k5OMfsZA4ezUrksJk
 WcwWbwL0qVclro1O1rPdeuLWwlQvCHswKa3Q/LHE03BdlEEKgq
 bA/umAmJlB544cdnz6fjITBo5Hz4ZguyeSjXUzeqSk4jRmw4uh
 ne6kUU5ggLnoQGm6iVsc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 17:07:47 Arnd Bergmann wrote:

> The current version doesn't let you do that, so I'll keel the #ifdef
> sections separate. This also means that I won't apply your patch 17:
> we will keep needing the #ifdef to support all three relevant combinations:
> 
> a) architectures that provide neither and want to get the defaults
>    from asm-generic
> b) architectures that provide the non-relaxed versions and want tog
>    to get just the relaxed version from asm-generic
> c) architectures that provide both
> 

And here is the new version I applied:

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 508a57257de5..3e976be3bdd4 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -174,6 +174,43 @@ static inline void writeq(u64 value, void __iomem *addr)
 #endif /* CONFIG_64BIT */
 
 /*
+ * {read,write}{b,w,l,q}_relaxed() are like the regular version, but
+ * are not guaranteed to provide ordering against spinlocks or memory
+ * accesses.
+ */
+#ifndef readb_relaxed
+#define readb_relaxed readb
+#endif
+
+#ifndef readw_relaxed
+#define readw_relaxed readw
+#endif
+
+#ifndef readl_relaxed
+#define readl_relaxed readl
+#endif
+
+#ifndef readq_relaxed
+#define readq_relaxed readq
+#endif
+
+#ifndef writeb_relaxed
+#define writeb_relaxed writeb
+#endif
+
+#ifndef writew_relaxed
+#define writew_relaxed writew
+#endif
+
+#ifndef writel_relaxed
+#define writel_relaxed writel
+#endif
+
+#ifndef writeq_relaxed
+#define writeq_relaxed writeq
+#endif
+
+/*
  * {read,write}s{b,w,l,q}() repeatedly access the same memory address in
  * native endianness in 8-, 16-, 32- or 64-bit chunks (@count times).
  */


