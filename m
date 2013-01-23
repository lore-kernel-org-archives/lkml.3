Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3AWV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:56:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48641
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab3AWV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:56:32 -0500
Date: Wed, 23 Jan 2013 18:56:13 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 11/15] tools/lib/traceevent/event-parse.c: adjust
 duplicate test
Message-ID: <20130123215613.GC6687@ghostprotocols.net>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358773378-4700-12-git-send-email-Julia.Lawall@lip6.fr>
 <1358952137.21576.117.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358952137.21576.117.camel@gandalf.local.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 23, 2013 at 09:42:17AM -0500, Steven Rostedt escreveu:
> On Mon, 2013-01-21 at 14:02 +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Delete successive tests to the same location.  Field was already tested.
> > Alloc_arg can fail, so test that value instead.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)

This one was fixed already by the patch below, that is in my perf/core
branch:

commit 9b9af6013045d58e95ecce62a1cfb34b150b7a8d
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Fri Dec 21 15:00:58 2012 -0500

    tools lib traceevent: test correct variable after allocation
    
    we've tested the wrong variable for allocation failure, fix it to
    test the right one.
