Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3LTVdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:33:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41512 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3LTVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:33:51 -0500
Date: Fri, 20 Dec 2013 22:33:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131220213348.GE7959@laptop.programming.kicks-ass.net>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217153611.GA18321@redhat.com>
 <20131217154004.GA21656@redhat.com>
 <20131220190157.GA1452@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220190157.GA1452@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 08:01:57PM +0100, Oleg Nesterov wrote:
> The only problem is that
> 
> 	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))
> 
> obviously can't work in this case ;) We need something more clever.

Hmm indeed, C++ has both the const_cast<>() thingy and the template
system is powerful enough to actually implement const_cast<>() inside
the language.

But I cannot find anything useful for C. Your attempt to use the rvalue
type to hopefully obtain a const-less lvalue type is clever, but does
indeed fail where the rvalue is const too.


