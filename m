Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaDDGyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:54:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaDDGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:54:10 -0400
Date: Thu, 3 Apr 2014 23:53:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Hansen <rhansen@bbn.com>
Cc: mtk.manpages@gmail.com, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Message-ID: <20140404065353.GA22039@infradead.org>
References: <533B04A9.6090405@bbn.com>
 <20140402111032.GA27551@infradead.org>
 <1396439119.2726.29.camel@menhir>
 <533CA0F6.2070100@bbn.com>
 <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
 <533DC357.1080203@bbn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533DC357.1080203@bbn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, I don't really see why you get so worked up about this.  There is
lots and lots of precedent of Linux allowing non-Posix (or non-standard
in general) arguments to system calls.  Even ones that don't have
symbolic names defined for them (the magic 3 open argument for device
files).

Given that we historicaly allowed the 0 argument to msync we'll have to
keep supporting it to not break existing userspace, and adding warnings
triggered by userspace that the person running the system usually can't
fix for something that is entirely harmless at runtime isn't going to
win you friends either.

A "strictly Posix" environment that catches all this sounds fine to me,
but it's something that should in the userspace c runtime, not the
kernel.  The kernel has never been about strict Posix implementations,
it sometimes doesn't even make it easy to implement the semantics in
user land, which is a bit unfortunate.
