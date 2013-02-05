Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3BEAEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:04:35 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43775 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3BEAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:04:34 -0500
Date: Tue, 5 Feb 2013 01:03:53 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: busses/i2c-pxa.c: fix potential null pointer
 dereference error
Message-ID: <20130205000353.GA9969@gmail.com>
References: <1360015899-13706-1-git-send-email-dinggnu@gmail.com>
 <CAH9JG2XSpFJeUvv7cw-JWadmi=X0-4EsN5FFKuDkwo=-mmzHSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2XSpFJeUvv7cw-JWadmi=X0-4EsN5FFKuDkwo=-mmzHSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 08:47:10AM +0900, Kyungmin Park wrote:
> Hi,
> 
> On Tue, Feb 5, 2013 at 7:11 AM, Cong Ding <dinggnu@gmail.com> wrote:
> > If it goes to eclk through line 1107, the variable res would be NULL. It will
> > cause a null pointer dereference error if we call release_mem_region.
> >
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  drivers/i2c/busses/i2c-pxa.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> > index 1034d93..eadf1a4 100644
> > --- a/drivers/i2c/busses/i2c-pxa.c
> > +++ b/drivers/i2c/busses/i2c-pxa.c
> > @@ -1211,7 +1211,8 @@ eremap:
> >  eclk:
> >         kfree(i2c);
> >  emalloc:
> > -       release_mem_region(res->start, resource_size(res));
> > +       if (!res)
> if (res)?
> It's not match with description. and it seems wrong.
sorry my fault. will send version 2.
 - cong
> 
> Thank you,
> Kyungmin Park
> > +               release_mem_region(res->start, resource_size(res));
> >         return ret;
> >  }
> >
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
