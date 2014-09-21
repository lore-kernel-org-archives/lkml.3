Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaIUQpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaIUQpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:45:47 -0400
Date: Sun, 21 Sep 2014 18:42:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, sparse@chrisli.org,
        Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 0/1] signal: use BUILD_BUG() instead of
	_NSIG_WORDS_is_unsupported_size()
Message-ID: <20140921164243.GA16744@redhat.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com> <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com> <541C4D57.9050507@nod.at> <1411141042.2513.3.camel@jtkirshe-mobl> <541C4E14.9010000@nod.at> <20140919172030.GA22293@redhat.com> <20140919212128.GP26432@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919212128.GP26432@jtriplet-mobl1>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Josh Triplett wrote:
>
> On Fri, Sep 19, 2014 at 07:20:30PM +0200, Oleg Nesterov wrote:
>
> > But I have to admit it looks a bit ugly to me anyway.
> > Can't we simply kill _NSIG_WORDS_is_unsupported_size ?
>
> This looks quite preferable.  Can you post that with a commit message
> and signoff?

OK, please see 1/1.

> Also, the indentation on the second of the three BUILD_BUG
> calls has some spaces in it, which it shouldn't.

Yes, thanks, and it makes sense to also fix the indentation.

> With those fixed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thanks. Could you ack it again?

I didn't preserve your ack because it seems that BUILD_BUG() and/or
BUILD_BUG_ON_MSG() deserve some cleanups... For example,

	if (0)
		BUILD_BUG();

can't be compiled if __compiletime_error_fallback() falls back to a
negative-size array (see the changelog).

But I think that the code above must be correct by definition, see
the comment and the original changelog (1399ff86f2a2 "kernel.h: add
BUILD_BUG() macro"). So if this patch breaks the compilation with
some compiler/version we should update include/linux/compiler-xxx.h
or fix BUILD_BUG().

Oleg.

 include/linux/signal.h |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

