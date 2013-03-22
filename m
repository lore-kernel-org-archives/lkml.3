Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423497Ab3CVXMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:12:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2838 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423404Ab3CVXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:12:49 -0400
Message-ID: <1363993967.1946.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/3] rbtree_test: add more rbtree integrity checks
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 22 Mar 2013 16:12:47 -0700
In-Reply-To: <CANN689GJeykvA1jt2m2iDEPwfvVFkkCdKBVoNYMoyr8T51cJCA@mail.gmail.com>
References: <1363648862.1774.18.camel@buesod1.americas.hpqcorp.net>
	 <CANN689GJeykvA1jt2m2iDEPwfvVFkkCdKBVoNYMoyr8T51cJCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 20:36 -0700, Michel Lespinasse wrote:
> On Mon, Mar 18, 2013 at 4:21 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > When checking the rbtree, account for more properties:
> >
> >    - Both children of a red node are black.
> >    - The tree has at least 2**bh(v)-1 internal nodes.
> 
> > -               WARN_ON_ONCE(is_red(rb) &&
> > -                            (!rb_parent(rb) || is_red(rb_parent(rb))));
> > +
> > +               if (is_red(rb)) {
> > +                       /*
> > +                        * root must be black and no path contains two
> > +                        * consecutive red nodes.
> > +                        */
> > +                       WARN_ON_ONCE(!rb_parent(rb) || is_red(rb_parent(rb)));
> > +
> > +                       /* both children of a red node are black */
> > +                       WARN_ON_ONCE(is_red(rb->rb_left) || is_red(rb->rb_right));
> > +               }
> 
> This seems quite redundant with the previous test - if we're going to
> visit each children, then at that point we're going to check that they
> can't be black if their parent (the current node) is black. So I don't
> see that the tests adds any coverage.

Hmm ok I see your point. I'll drop this test and just keep the last one.

Thanks for taking a look,
Davidlohr

