Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbbASI2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:28:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbASI2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:28:17 -0500
Date: Mon, 19 Jan 2015 00:28:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Message-ID: <20150119082815.GA26697@infradead.org>
References: <1421600146.2080.8.camel@HansenPartnership.com>
 <54BC93C3.7010808@hitachi.com>
 <878ugzco8c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ugzco8c.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 04:21:15PM +1030, Rusty Russell wrote:
> The first one I think should be eliminated, and the second one is simply
> an assertion before calling module_put() (which should probably be
> eliminated).  The others are just printing information.

FYI, I've got a pathcset to eliminate the use of module_refcount in
SCSI, which was a horrible hack to start with, but it needs a little more
clarification / work, so I'd prefer to do it for 3.20.  Bart has a fix
that eliminates it for 3.19, which piles aother bandaid over the bandaid
that introduced the use module_refcount, and James doesn't seem to like
it.
