Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaGLM1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:27:41 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58984 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaGLM1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:27:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 2/3] ARM: Use include/asm-generic/io.h
Date: Sat, 12 Jul 2014 14:27:22 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com> <1405092672-18549-2-git-send-email-thierry.reding@gmail.com> <20140711162422.GF16321@arm.com>
In-Reply-To: <20140711162422.GF16321@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407121427.22668.arnd@arndb.de>
X-Provags-ID: V02:K0:Ch42mFdAowhEjajMsm3EzdXlWrBOwbbMvd73sLQcdcM
 xj8W6u9xIF/vcWtFW3ZrWzQVykQ44y1S+hG5FOshape+HAj+xG
 C+i+UP5ngzulxzQ+LudkG/c671JCpNdUc5GELlRFF7RVnkJCwi
 onvj2SN4QEtS8mNZFYNPHjhi4WxH3iZWZmta68wmsg3uIxrw7r
 vZtX8T3w4Wtu0EqgMuJtYnJe4oAQ5ThRt4l66BnpC2kECv3vkq
 tVotq4btDOaIKC2AaLQOyVTUnP1USptqQ7juTTanlPt/RLYKqE
 VL45YyLZDGxV5ynrzGIjThaIdbJOqapSMZ/Q6QL3qXczrUi/tY
 deU8kmmGGQoK9m6HgaCk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Catalin Marinas wrote:
> 
> On Fri, Jul 11, 2014 at 04:31:11PM +0100, Thierry Reding wrote:
> > diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> > index a78562f21aab..ef54f5c8a7ae 100644
> > --- a/arch/arm/include/asm/io.h
> > +++ b/arch/arm/include/asm/io.h
> [...]
> > -#define iowrite16be(v,p) ({ __iowmb(); __raw_writew((__force __u16)cpu_to_be16(v), p); })
> > -#define iowrite32be(v,p) ({ __iowmb(); __raw_writel((__force __u32)cpu_to_be32(v), p); })
> 
> Aren't you losing the barrier semantics here? The generic iowrite*be()
> functions call __raw_write*() directly which don't have a barrier
> (write* accessors do).
> 

Indeed, sorry for missing this. The generic implementation still makes sense for
include/asm-generic, but arm32 and arm64 must provide their own versions here.

An alternative would be to define

#define iowrite32be(v, p) iowrite32(swab32(v), p)

which is correct but can end up swapping multiple twice.

	Arnd
