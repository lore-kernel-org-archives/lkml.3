Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaLPPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:15:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaLPPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:15:46 -0500
Date: Tue, 16 Dec 2014 16:15:21 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
Message-ID: <20141216161521.1f72e102@redhat.com>
In-Reply-To: <alpine.DEB.2.11.1412160852460.27498@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<20141215080338.GE4898@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412150815210.20101@gentwo.org>
	<20141216024210.GB23270@js1304-P5Q-DELUXE>
	<CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
	<20141216082555.GA6088@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412160852460.27498@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014 08:53:08 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Tue, 16 Dec 2014, Joonsoo Kim wrote:
> 
> > > Like this:
> > >
> > >         return d > 0 && d < page->objects * s->size;
> > >
> >
> > Yes! That's what I'm looking for.
> > Christoph, how about above change?
> 
> Ok but now there is a multiplication in the fast path.

Could we pre-calculate the value (page->objects * s->size) and e.g store it
in struct kmem_cache, thus saving the imul ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
