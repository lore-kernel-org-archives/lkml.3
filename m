Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaFGS5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 14:57:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:60168 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaFGS5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 14:57:43 -0400
Message-ID: <1402167452.4806.0.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] dns_resolver: assure that dns_query() result is
 null-terminated
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "Miller David S." <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 07 Jun 2014 20:57:32 +0200
In-Reply-To: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com>
References: <1402163811-21604-1-git-send-email-manuel.schoelling@gmx.de>
	 <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:/hMT6ls27st2Z0u/Y5s1d1ACQi5m3hFBz/L/Dy6wBJpeJlJkNYQ
 C7MONnhPGck6dTf7jDsPHQuOVd+Rrys8FyWTZyej3F/9cIF4NI9bubJ8qltTNTw0chhFrD/
 MrFK37SSu3DJuioGwZ5db/nKJw4AopXAnctYzoJzGx1gegmHrKU4rsG7mdEkLz/B/gR2a87
 vOqBoXcZm9cq/yiz3rJeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LOL, that was stupid!
Sorry, I'll send a corrected version in a second...

On Sa, 2014-06-07 at 14:54 -0400, Trond Myklebust wrote:
> On Sat, Jun 7, 2014 at 1:56 PM, Manuel Schölling
> <manuel.schoelling@gmx.de> wrote:
> > dns_query() credulously assumes that keys are null-terminated and
> > returns a copy of a memory block that is off by one.
> > ---
> >  net/dns_resolver/dns_query.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> > index e7b6d53..53be635 100644
> > --- a/net/dns_resolver/dns_query.c
> > +++ b/net/dns_resolver/dns_query.c
> > @@ -149,7 +149,9 @@ int dns_query(const char *type, const char *name, size_t namelen,
> >         if (!*_result)
> >                 goto put;
> >
> > -       memcpy(*_result, upayload->data, len + 1);
> > +       memcpy(*_result, upayload->data, len);
> > +       *_result[len+1] = '\0';
> 
> Off by one...
> 
> > +
> >         if (_expiry)
> >                 *_expiry = rkey->expiry;
> >
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


