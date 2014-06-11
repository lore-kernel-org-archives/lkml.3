Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaFKVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:32:49 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:55725 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaFKVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:32:48 -0400
Date: Wed, 11 Jun 2014 14:32:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ralf Baechle <ralf@linux-mips.org>
cc: Eunbong Song <eunb.song@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: mips: math-emu: Fix compilation error ieee754.c
In-Reply-To: <20140611171000.GD26335@linux-mips.org>
Message-ID: <alpine.DEB.2.02.1406111427170.27885@chino.kir.corp.google.com>
References: <2463243.264261402478691777.JavaMail.weblogic@epml26> <20140611171000.GD26335@linux-mips.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Ralf Baechle wrote:

> On Wed, Jun 11, 2014 at 09:24:51AM +0000, Eunbong Song wrote:
> 
> > ieee754dp has bitfield member in struct without name. And this
> > cause compilation error. This patch removes struct in ieee754dp
> > declaration. So compilation error is fixed.
> > Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> 
> What gcc version are you using?
> 

make arch/mips/math-emu/ieee754.o for mips defconfig triggers the 
following on linux-next 30 times:

arch/mips/math-emu/ieee754.c:45:2: error: unknown field 'sign' specified in initializer
arch/mips/math-emu/ieee754.c:45:2: warning: missing braces around initializer
arch/mips/math-emu/ieee754.c:45:2: warning: (near initialization for '__ieee754dp_spcvals[0].<anonymous>')
arch/mips/math-emu/ieee754.c:45:2: error: unknown field 'bexp' specified in initializer
arch/mips/math-emu/ieee754.c:45:2: warning: excess elements in union initializer
arch/mips/math-emu/ieee754.c:45:2: warning: (near initialization for '__ieee754dp_spcvals[0]')
arch/mips/math-emu/ieee754.c:45:2: error: unknown field 'mant' specified in initializer
arch/mips/math-emu/ieee754.c:45:2: warning: excess elements in union initializer
arch/mips/math-emu/ieee754.c:45:2: warning: (near initialization for '__ieee754dp_spcvals[0]')

I'm using gcc 4.5.1 for mips.  The patch makes all members part of the 
union so it's probably not what you want to fix it, though.
