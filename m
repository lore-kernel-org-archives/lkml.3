Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3GXRRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:17:32 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:42972 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:17:31 -0400
Date: Wed, 24 Jul 2013 21:17:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130724171728.GH8508@moon>
References: <20130724160826.GD24851@moon>
 <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
 <20130724163734.GE24851@moon>
 <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:06:53AM -0700, Andy Lutomirski wrote:
> > Hi Andy, if I understand you correctly "file-backed pages" are carried
> > in pte with _PAGE_FILE bit set and the swap soft-dirty bit won't be
> > used on them but _PAGE_SOFT_DIRTY will be set on write if only I've
> > not missed something obvious (Pavel?).
> 
> If I understand this stuff correctly, the vmscan code calls
> try_to_unmap when it reclaims memory, which makes its way into
> try_to_unmap_one, which clears the pte (and loses the soft-dirty bit).

Indeed, I was so stareing into swap that forgot about files. I'll do
a separate patch for that, thanks!
