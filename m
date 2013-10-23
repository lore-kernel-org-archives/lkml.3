Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3JWKDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:03:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JWKDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:03:08 -0400
Date: Wed, 23 Oct 2013 03:03:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kirill@shutemov.name
Subject: Re: [PATCH, RFC] what's the point of mtd_inodefs?
Message-ID: <20131023100303.GA20373@infradead.org>
References: <20131022153313.GA11923@infradead.org>
 <CAFLxGvwk0gbejxk6hmnu+Cw=TgXGh0=MKgSyKtm7nTVJiBBgeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwk0gbejxk6hmnu+Cw=TgXGh0=MKgSyKtm7nTVJiBBgeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 07:50:17AM +0200, Richard Weinberger wrote:
> On Tue, Oct 22, 2013 at 5:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > I've been looking at mtdchar as part of a bigger series touching all
> > kidns of places and really wonder what the point of mtd_inodefs is.
> 
> As far I can tell it was introduced because of that issue:
> http://lists.infradead.org/pipermail/linux-mtd/2010-April/029593.html

Not sure how that issue came up as writeback only ever uses
mapping->backing_dev_info for block devices, else it only uses s_bdi to
avoid this issue.  As pointed out somewhere in that thread the mem
driver uses a similar scheme.

