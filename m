Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbaGQKuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:50:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54004 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaGQKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:50:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 38/38] asm-generic: introduc Kbuild.generic
Date: Thu, 17 Jul 2014 12:50:07 +0200
Message-ID: <5003088.VRbrHdWpA3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140717103815.GA16291@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org> <4667634.oiTEQ4v5vj@wuerfel> <20140717103815.GA16291@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LeGgmsiQ8UR0mGr0Utd6WFgxKIs1u676nB+t3DKjXg7
 gLA9aXhPepYx2CQSGaL7UJvap15jDCWxA0TAMgN72ZUDMgSm11
 gob+Z31rvUMTzoEDTRKFo2dMKWXNEsHO0TixIOauE76jC+QY6h
 Mkq2Ab6bQkoy2iRuiH8Fy0UCPAX9Clexzxu4a2N9ckpCu+/h6T
 7tbhu4IBWY90GOfrEWMx68MkP5OPTw6NQr0l1Yooz7tspA1YXL
 BYQW0bDBEDkKAWrISjttAqaj8YvcXNKgwnhM5UXHwEiNkWnkJ/
 wKXu45ZVQ1nbeOQzse4Lg5dTiDU4sOT7kx1FJPCdyNeFgZms6t
 4T+PBqw5TT6ShDNQZTDo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 12:38:15 Sam Ravnborg wrote:
> > * We could improve the situation if the definition of this list is
> >   changed so we only generate the generic header files that are not
> >   already provided by an architecture. If we do this, we can consolidate
> >   a lot more here, which is nice, but the cost would be equivalent to
> >   another level of indirection and a potential for subtle bugs if it's
> >   not done very careful.
> I think this is the way to go - and will try to give it a spin.
> 
> Something along these lines:
> include/asm-generic/Kbuild.asm will include a list of all header files
> that shall be present for any architecture and may come from asm-generic.
> If the architecture provide there own file - good.
> If the architecture do not provide their own file => create wrapper.
> 
> The arch provided header file comes first in the search path,
> so if a wrapper was generated and later a dedicated file is added
> then we will use the dedicated file and not the wrapper that points
> back to asm-generic.
> 
> The same logic applies for uapi/asm-generic as well.
> 
> I will try to come up with an implementation of this,
> then we can see if this flys.

Ok, sounds good. Thanks!

	Arnd
