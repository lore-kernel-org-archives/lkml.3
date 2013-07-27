Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3G0VBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 17:01:47 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34899 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3G0VBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 17:01:46 -0400
Date: Sun, 28 Jul 2013 01:01:43 +0400
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
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130727210143.GA2524@moon>
References: <20130726201807.GJ8661@moon>
 <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
 <20130726211844.GB8508@moon>
 <CALCETrW7Ukh8KfKzpNgRc1D_5OK1o7bmEmFbtQTYoSoFiOSeKw@mail.gmail.com>
 <20130727062512.GC8508@moon>
 <CALCETrWbF_e98w0d9-0tLOaTUv-mZv_RQgqOpuNiVaDOacHT0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWbF_e98w0d9-0tLOaTUv-mZv_RQgqOpuNiVaDOacHT0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 10:06:01AM -0700, Andy Lutomirski wrote:
> 
> That being said, a MAP_PRIVATE, un-cowed mapping must be clean -- if
> it had been (soft-)dirtied, it would also have been cowed.  So you
> might be okay.

Yas, as far as I know we are either cow'ed or in clean state, thus
either soft-bit set on #pf (and when reclaimed rest in file-pte)
or it remains clean and there is no change we need to track.
