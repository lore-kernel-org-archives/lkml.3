Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLPOxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:53:32 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:47887 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbaLPOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:53:11 -0500
Date: Tue, 16 Dec 2014 08:53:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
In-Reply-To: <20141216082555.GA6088@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1412160852460.27498@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141210163033.717707217@linux.com> <20141215080338.GE4898@js1304-P5Q-DELUXE> <alpine.DEB.2.11.1412150815210.20101@gentwo.org> <20141216024210.GB23270@js1304-P5Q-DELUXE> <CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
 <20141216082555.GA6088@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Joonsoo Kim wrote:

> > Like this:
> >
> >         return d > 0 && d < page->objects * s->size;
> >
>
> Yes! That's what I'm looking for.
> Christoph, how about above change?

Ok but now there is a multiplication in the fast path.

