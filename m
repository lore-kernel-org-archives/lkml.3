Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaGBOu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:50:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGBOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:50:28 -0400
Date: Wed, 2 Jul 2014 07:50:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Sch?bel-Theuer <tst@1und1.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140702145024.GA19425@infradead.org>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
 <20140702082400.GB10971@kroah.com>
 <20140702132708.GA26732@infradead.org>
 <53B418FA.80600@1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B418FA.80600@1und1.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 04:36:42PM +0200, Thomas Sch?bel-Theuer wrote:
> However, I probably would have to "borrow" large parts of the
> sys_rmdir() implementation from fs/namei.c (the only real difference
> appears to me that the pathname is not in userspace).
> 
> So, what is worse: copying relatively large pieces of code, or using
> sys_rmdir()?

Most likely you shouldn't do either.  A block driver really should not
be removing directories from the filesystem namespace.

