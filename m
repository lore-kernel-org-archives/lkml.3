Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3COK51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:57:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3COK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:57:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
Date: Fri, 15 Mar 2013 10:56:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrea Adami <andrea.adami@gmail.com>, Chen Gang <gang.chen@asianux.com>,
        matthew.leach@arm.com, dave.martin@linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>, nico@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        matthew.gretton-dann@linaro.org
References: <51415428.1070401@asianux.com> <514270D2.9010205@asianux.com> <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com>
In-Reply-To: <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <201303151056.55819.arnd@arndb.de>
X-Provags-ID: V02:K0:FsYiqV/x6GgSY7VF8blAHgg9tdz4YZUxVnn0K54I7x8
 uguKIKrgEfjg8Xnne/9QsRs8AbMUN/vv+rcBvENYQcSzg2MKi9
 7uxgGdUNW8Dbj5z96J4YyT9b9JIxqbTBH04GtRWrTR99QGEhbI
 EYTuhmtVZf8n9R/6Azqi+nMKTfhEtTIEKzhyyvE64Li+N8WWZM
 iPdt0KXyWnu5uhQixpvWPB4qU7XFsvgWsbmRv/Ydn0h62vfZ02
 /pzBHoL5zgd8689GQClhP2Q1NreVWbzSl84MjONkcAEjmGF+0V
 DJhWPwgesRn4C+3nJ65g3w6jQHHyQR4gq58tZ8rLhrhcbpCUNX
 bR0AqN974v1RIbAwYYW8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Andrea Adami wrote:
> On Fri, Mar 15, 2013 at 1:52 AM, Chen Gang <gang.chen@asianux.com> wrote:
> > 于 2013年03月15日 07:43, Russell King - ARM Linux 写道:
> >> So our wonderful toolchain has decided to start producing NULL warnings
> >> for every "mcr     p15, 0, rX, c7, c10, 4" instruction?  I'd just ignore
> >> them and hope that the toolchain people fix it.
> 
> AFAIK Arnd is aware and waiting for feedback about his patch:
> 
> ARM: compressed/head.S: work around new binutils warning   Arnd Bergmann
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/144846.html

Right. The fact that as prints a warning for those instructions makes sense
given that we are telling it we want to run on *all* ARM architectures,
and that ARMv8 has deprecated them officially.

Of course, what is bogus about this is the "NULL" part rather than printing
the text that was meant to come out to explain the situation.  I don't
know how to report that bug other than what I tried before, but if it gets
fixed by printing the right text, we will still want to build a kernel
without getting any warnings.

	Arnd
