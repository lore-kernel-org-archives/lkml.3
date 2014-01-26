Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaAZVim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:38:42 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48554 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaAZVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:38:40 -0500
Date: Sun, 26 Jan 2014 13:38:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ren Qiaowei <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
In-Reply-To: <52E4919B.8050408@intel.com>
Message-ID: <alpine.DEB.2.02.1401261335400.26515@chino.kir.corp.google.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com> <52E4919B.8050408@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-2146613219-1390772190=:26515"
Content-ID: <alpine.DEB.2.02.1401261336480.26515@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-2146613219-1390772190=:26515
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1401261336481.26515@chino.kir.corp.google.com>

On Sun, 26 Jan 2014, Ren Qiaowei wrote:

> > arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
> > arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of
> > different size [-Wint-to-pointer-cast]
> > arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of
> > different size [-Wint-to-pointer-cast]
> > 
> > and the documentation says you explicitly want to support this config.
> > 
> > These types of warnings are usually indicative of real problems when
> > you're storing upper and lower bits in 32-bit fields after casting them
> > from 64-bit values.
> > 
> > I'm also not sure if the added fields to the generic struct siginfo can be
> > justified for this.
> > 
> According to MPX spec, for 32-bit case, the upper 32-bits of 64-bits bound
> register are ignored, and so casting to pointer from 64-bit values should be
> not produce any problems.
> 

Ok, so this is intended per the spec which nobody reading the code is 
going to know and people who report the compile warnings are going to 
continue to question it.

How are you planning on suppressing the warnings?  It will probably 
require either

 - separate 64-bit and 32-bit helper functions to do_mpx_bounds() to 
   do appropriate casts before casting to a pointer, or

 - a macro defined as a no-op for 64-bit and as a cast to 32-bit value
   for 32-bit configs that will be used in do_mpx_bounds() and casted
   to the pointer.
--531381512-2146613219-1390772190=:26515--
