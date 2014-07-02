Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaGBSkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:40:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaGBSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:40:51 -0400
Date: Wed, 2 Jul 2014 11:40:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
Message-ID: <20140702184050.GA24583@infradead.org>
References: <53B3D3AA.3000408@samsung.com>
 <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
> It's acceptable.

It's not because it will then also affect other reads going on at the
same time.

The whole concept of ima is just broken, and if you want to do these
sort of verification they need to happen inside the filesystem and not
above it.

We really should never have merged ima, and I think we should leave
these sorts of issue that have been there since day one unfixed and
deprecate it instead of adding workaround on top of workaround.

