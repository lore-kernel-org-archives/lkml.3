Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbaDBL1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:27:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28690 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbaDBL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:27:29 -0400
Date: Wed, 2 Apr 2014 14:26:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>, kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch] clk: vt8500: several forever loops
Message-ID: <20140402112653.GK18506@mwanda>
References: <20130826154908.GD12428@elgon.mountain>
 <20140402110429.GJ18506@mwanda>
 <CAKv+Gu9R7Y5OKy+P62FAyE2_zf7f=reiLQy-++XziXahbSM15A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9R7Y5OKy+P62FAyE2_zf7f=reiLQy-++XziXahbSM15A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:19:19PM +0200, Ard Biesheuvel wrote:
> On 2 April 2014 13:04, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > This patch is still needed in linux-next.  It was Acked by Tony Prisk in
> > a private email.
> >
> > Acked-by: Tony Prisk <linux@prisktech.co.nz>
> >
> > regards,
> > dan carpenter
> >
> > On Mon, Aug 26, 2013 at 07:02:33PM +0300, Dan Carpenter wrote:
> >> This does a bunch of looping like this:
> >>
> >>       for (div2 = 7; div2 >= 0; div2--)
> >>
> >> But unsigned values are always greater than or equal to zero so it just
> >> loops and loops.  Really "mul", "div1" and "div2" should all be declared
> >> as int for cleanliness sake.
> >>
> 
> Apologies if this is a silly question from someone who is utterly
> uninformed, but are values == 0 even legal for divisors?
> It seems that, at least in some cases, 'div - 1' is or'ed into a
> register value (WM8850_BITS_TO_VAL), and I don't think you are
> expecting negative values there.
> So perhaps instead, change the test to '> 0' ??

Those seem like totally valid points.  The truth is that I almost am
"utterly uninformed" about this code.  Perhaps someone who knows more
than the both of us could take a look?

Please give Ard and me reported by tags when you fix this.

regards,
dan carpenter

