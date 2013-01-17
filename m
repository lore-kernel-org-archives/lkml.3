Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3AQShs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:37:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3AQShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:37:46 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1dK1Tq4abSwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=daFlbPKOXuoA:10 a=HTFWD6ZW6W2I5QXYU04A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358447864.23211.34.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] slub: Check for page NULL before doing the
 node_match check
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Thu, 17 Jan 2013 13:37:44 -0500
In-Reply-To: <1358446258.23211.32.camel@gandalf.local.home>
References: <1358446258.23211.32.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 13:10 -0500, Steven Rostedt wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 2d9511a..85b95d5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2399,7 +2399,7 @@ redo:
>  
>  	object = c->freelist;
>  	page = c->page;
> -	if (unlikely(!object || !node_match(page, node)))
> +	if (unlikely(!object || !page || !node_match(page, node)))

I'm still trying to see if c->freelist != NULL and c->page == NULL isn't
a bug. The cmpxchg_doubles are a little confusing. If it's not expected
that page is NULL but freelist isn't than we need to figure out why it
happened.

-- Steve

>  		object = __slab_alloc(s, gfpflags, node, addr, c);
>  
>  	else {
> 
> 


