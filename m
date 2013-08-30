Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3H3X2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:28:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53635 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654Ab3H3X2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:28:40 -0400
Message-ID: <1377905319.2070.38.camel@joe-AO722>
Subject: Re: do_div() silently truncates "base" to 32bit
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        bernie@develer.com, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 30 Aug 2013 16:28:39 -0700
In-Reply-To: <52212128.3000100@infradead.org>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	 <52210D34.5030807@infradead.org>
	 <CAOMFOmUav+3UqR9s5LF6n4c4oXZ-K5oBJrmLtz-PMY053vH8Rg@mail.gmail.com>
	 <52212128.3000100@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 15:48 -0700, Randy Dunlap wrote:
> On 08/30/13 15:14, Anatol Pomozov wrote:
> > But another question still remains: why compiler does not warn that
> > size truncation happens? How to prevent bugs like CFQ one in the
> > future? Should we add a compile-time assert to do_div() to prevent
> > passing 64 numbers in "base" macro parameter?
> That sounds like a fine idea to me.

Geert thought so too and submitted a patch

http://www.spinics.net/lists/linux-btrfs/msg26788.html


