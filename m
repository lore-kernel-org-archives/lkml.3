Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaFNVRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:17:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50080 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752623AbaFNVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:17:31 -0400
Date: Sat, 14 Jun 2014 23:17:27 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Himangi Saraogi <himangi774@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] iio: adc: at91_adc: Correct call to input_free_device
Message-ID: <20140614211727.GA3137@piout.net>
References: <20140613171146.GA2831@himangi-Dell>
 <539C6D20.7080907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539C6D20.7080907@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/2014 at 16:41:20 +0100, Jonathan Cameron wrote :
> On 13/06/14 18:11, Himangi Saraogi wrote:
> >This error handling code can be reached before st->ts_input is
> >initialized, so it is safer to always use the original name, input_dev.
> >
> >A simplified version of the semantic match that finds this problem is:
> >
> >// <smpl>
> >@r exists@
> >local idexpression struct input_dev * x;
> >expression ra,rr;
> >@@
> >
> >* x = input_allocate_device(...)
> >...  when != x = rr
> >      when != input_free_device(x,...)
> >      when != if (...) { ... input_free_device(x,...) ...}
> >if(...) { ... when != x = ra
> >      when forall
> >*     when != input_free_device(x,...)
> >  \(return <+...x...+>; \| return...; \) }
> >
> >// </smpl>
> >
> >Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> The error handling in this function has been completely rewritten so the
> bug is no longer there and this no longer applies.

Hum, actually, you are wrong and I introduced that bug in 3.16. The
change didn't come from your tree so it is not up to date.

So either you take it after 3.16-rc1 or we can ask Nicolas to get it
through the at91 tree.


Either way:

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
