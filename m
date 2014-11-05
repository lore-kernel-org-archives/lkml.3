Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaKEIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:25:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKEIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:25:58 -0500
Date: Wed, 5 Nov 2014 00:25:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Allison <jra@samba.org>
Cc: Eric Rannaud <e@nanocritical.com>, Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
Message-ID: <20141105082555.GA19607@infradead.org>
References: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
 <20141031084220.GA29085@infradead.org>
 <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
 <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
 <20141103083447.GA8617@infradead.org>
 <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
 <CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
 <20141103220707.GJ5389@samba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103220707.GJ5389@samba2>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 02:07:07PM -0800, Jeremy Allison wrote:
> Which we already do, actually..

Hmm, I didn't notice that part when implementing the atomic open,
guess I need to dig deeper into the code.

I still think supporting full open semantics with O_TMFILE + flink is
useful, so that others can make use of it it without such an additional
enforcement layer.
