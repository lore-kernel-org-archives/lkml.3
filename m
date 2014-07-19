Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbaGSJLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:11:15 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55542 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaGSJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:11:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Sat, 19 Jul 2014 11:10:25 +0200
Message-ID: <5140022.LHa9ZBVSGJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140719085338.GB31564@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com> <5913515.3g98ODuH6W@wuerfel> <20140719085338.GB31564@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rTS9Y7bVxxxsxq+exKB5P8M1/jrfzWycoxr8GvZ3t3d
 CrAAWde+4pZzChIuB9onABQqS4qWBbr7nYzy2mT3KFdDtuSJ1n
 6p3pIgjv+OdvVqLTE5ivFOM7OhdMgfoCaV0eh+vlc7IKD03FM8
 NOYg8Q3mITR6HHhQYA8zxa8fRAulPUTbH4YTF6wgEPLZjb74B7
 maO84wWPMvA/KfxwqQ9MhnooaOsxHgI1tTgGIH5atCDo66P0If
 K7abAqy+MJttO5W2iNmg364nm0RJepE3xLtVyKeZiBiTFzMrUe
 UwzgOKofBL1R2lfAVkrSaKFjv05JvFnuSl11vVVgkQvHjM8CXT
 aoXZtAgsrDuz20ABEznU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2014 10:53:38 Sam Ravnborg wrote:
> 
> Then there are the other type where one IO access function
> may re-use the implementation of another IO access function:
> 
>     #ifndef writeb
>     #define writeb __raw_writeb
>     #endif
> 
> This could have been implmented like this:
> 
> #ifndef writeb
> #define writeb writeb
> static inline void writeb(u8 b, volatile void __iomem *addr)
> {
>    __raw_writeb(b, addr);
> }
> #endif
> 
> In this way the prototype of the function is easy to understand and
> we avoid the macro tricks were we blindly replace one function name,
> with another function name.
> And we also use the same pattarn all over for the various functions.
> 
> Concerning the efficiency the compiler should be smart enough to
> do the same independent on the two implmentations.

I really don't have a strong opinion on those, as you say one is a
little shorter and the other is a little more readable, so my
preference in a case like this is to leave it up to the person
who last touches the code and let them decide.

	Arnd
