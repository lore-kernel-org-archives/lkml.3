Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaFQAVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:21:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23407 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753737AbaFQAV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:21:29 -0400
Date: Mon, 16 Jun 2014 20:21:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using
 min and max
Message-ID: <20140616202120.27364ed9@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1406161652490.21018@chino.kir.corp.google.com>
References: <1402952842-12886-1-git-send-email-mina86@mina86.com>
	<20140616161804.bb06ed842f59371c031d1252@linux-foundation.org>
	<alpine.DEB.2.02.1406161621530.21018@chino.kir.corp.google.com>
	<20140616163525.46933b64320e220a6d806bb4@linux-foundation.org>
	<alpine.DEB.2.02.1406161652490.21018@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 16:54:32 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> 
> 
> On linux-next, allyesconfig has a 0.0001% savings as a result of the 
> patch, but I'd be worried about the extra temp variable it allocates on 
> the stack that is evident in the mm/slab.c disassembly unless all cases 
> can be audited to show that we're not potentially deep.

A 0.0001% change means it's not worth changing, and we may be able to
mark this up as a fluke in Michal's results.

I'll give it a try on my 4.6.3 compiler.

-- Steve

> 
>    text	   data	    bss	    dec	    hex	filename
> 108573045	23488016	51580928	183641989	af22785	vmlinux.before
> 108572908	23488016	51580928	183641852	af226fc	vmlinux.after

