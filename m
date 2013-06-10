Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3FJQEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:04:21 -0400
Received: from 1wt.eu ([62.212.114.60]:36238 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3FJQET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:04:19 -0400
Date: Mon, 10 Jun 2013 18:04:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: Re: Linux 2.6.32.61
Message-ID: <20130610160405.GI2685@1wt.eu>
References: <20130610101557.GA3235@1wt.eu> <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven-Haegar,

On Mon, Jun 10, 2013 at 05:11:49PM +0200, Sven-Haegar Koch wrote:
> On Mon, 10 Jun 2013, Willy Tarreau wrote:
> 
> > Willy Tarreau (2):
> >       x86, ptrace: fix build breakage with gcc 4.7
> 
> This change breaks "make headers_install":
> 
>   CHECK   include (0 files)
>   CHECK   include/asm (54 files)
> /home/haegar/src/2.6.32/linux/usr/include/asm/ptrace.h:5: included file 'linux/linkage.h' is not exported
> make[3]: *** [/home/haegar/src/2.6.32/linux/usr/include/asm/.check] Error 123
> make[2]: *** [headers_check] Error 2
> make[1]: *** [deb-pkg] Error 2
> make: *** [deb-pkg] Error 2

Grrr... seems like we'll need to fix the gcc 4.7 build issue differently
because we probably don't want to export linux/linkage.h just to make
the __attribute__((regparm=3)) appear in one arch-specific file.

I'll check if the definition in the include is really needed after I
install a gcc 4.7 cross-compiler.

Thanks for your report, and sorry for the mess.

Willy

