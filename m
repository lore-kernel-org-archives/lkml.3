Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaGVTYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:24:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46791 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGVTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:24:01 -0400
Message-ID: <1406057037.29265.4.camel@gmail.com>
Subject: Re: [RFC] 3.16-rc6 -- fs/direct-io.c:1011 from and to uninitialized.
From: Ian Kumlien <ian.kumlien@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 21:23:57 +0200
In-Reply-To: <53CEB973.2080406@infradead.org>
References: <1406055834.23587.1.camel@gmail.com>
	 <53CEB973.2080406@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On tis, 2014-07-22 at 12:20 -0700, Randy Dunlap wrote:
> On 07/22/2014 12:03 PM, Ian Kumlien wrote:
> > This is a resend, try two... 
> > 
> > And while the fix is simple, something along the lines of:
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 98040ba..64a8286 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -910,7 +910,7 @@ static int do_direct_IO(struct dio *dio, struct
> > dio_submit *sdi
> >  
> >         while (sdio->block_in_file < sdio->final_block_in_request) {
> >                 struct page *page;
> > -               size_t from, to;
> > +               size_t from, to = {0};
> >                 page = dio_get_page(dio, sdio, &from, &to);
> >                 if (IS_ERR(page)) {
> >                         ret = PTR_ERR(page);
> > ---
> > 
> > I however don't know if it's in the correct C standard, it compiles fine
> > though... (or if this is more gcc speific)
> 
> so... do you know C or not?

I know C but i don't know if this got added in C99 or C11 or how they
denote it.

> Why the braces around the 0?

Because it's special

> Why do you initialize 'to' but not 'from'?

The magic of {0} is that it will initialize all your values.

