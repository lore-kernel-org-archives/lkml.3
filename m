Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3KREBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:01:18 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:64403 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3KREBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:01:08 -0500
X-AuditID: 1209190c-b7f7f6d000000bbd-9c-52899102540a
Date: Sun, 17 Nov 2013 23:01:00 -0500
From: Greg Price <price@MIT.EDU>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Erico Nunes <nunes.erico@gmail.com>, linux-sparse@vger.kernel.org,
        dwmw2 <dwmw2@infradead.org>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clarify error on directive in macro arguments (Re:
 [PATCH] jffs2: fix sparse errors: directive in argument list)
Message-ID: <20131118040100.GE8043@ringworld.MIT.EDU>
References: <20131118020746.GX16018@ringworld.MIT.EDU>
 <1384740932.5814.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384740932.5814.4.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsUixG6noss0sTPIYNUmA4uJKyczW8y+/5jF
	4vKuOWwWu5uWsVvcu72fxaKldwmjRdeaQ6wW5/8eZ3Xg8Fix6gqLx85Zd9k9Nq/Q8ti8pN7j
	y6przB6fN8l5bHrylimAPYrLJiU1J7MstUjfLoErY8rrrSwFE9kq9l+ewNjA+Jmli5GTQ0LA
	RKK9cwkzhC0mceHeerYuRi4OIYHZTBKPztxlhXA2MkpsOz+NEcL5xSjxdeUyVpAWFgFViebe
	52Cj2AQUJH7MXwc0ioNDREBR4u4WfpB6ZoG5TBIHehaANQsLtDNKXHu6kQ2kgVfAVGLr9otg
	g4QEYiS2HNrNChEXlDg58wnYUGYBLYkb/14ygQxlFpCWWP6PAyTMKWAg8ezeZiYQW1RARWLK
	yW1sExgFZyHpnoWkexZC9wJG5lWMsim5Vbq5iZk5xanJusXJiXl5qUW6hnq5mSV6qSmlmxhB
	kcIpybOD8c1BpUOMAhyMSjy8DRGdQUKsiWXFlbmHGCU5mJREeY92AYX4kvJTKjMSizPii0pz
	UosPMUpwMCuJ8Jr4A+V4UxIrq1KL8mFS0hwsSuK8Nznsg4QE0hNLUrNTUwtSi2CyMhwcShK8
	DBOAGgWLUtNTK9Iyc0oQ0kwcnCDDeYCG3+0HGV5ckJhbnJkOkT/FqCglzrsZJCEAksgozYPr
	hSWyV4ziQK8I8z4DqeIBJkG47ldAg5mABh9/3gYyuCQRISXVwJgSpyfuFH5pSeO2yfe/7PC2
	ZPVkvsKzdOeuSydv8BmlbJ1RmRzSunS+oPUb5qOO7774P9jTpvfu0MGImPCrj1Oe/Lgwb8Kn
	pSe8bp0XV0l+0tbYLy+ZdUQnwsbh8vcsYWehrcxxE6YevnxqUXuWRuymU+fe/JhhVKc9e0dp
	4j4nNnmlysULCiYpsRRnJBpqMRcVJwIAQ5nAuD8DAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 06:15:32PM -0800, Joe Perches wrote:
> On Sun, 2013-11-17 at 21:07 -0500, Greg Price wrote:
> > Perhaps the following tweak to the error message would make this
> > subtlety clearer?
> 
> Maybe, but this case isn't a macro.  It's a function.
> Dunno if differentiating when it's a macro or a
> function is difficult though.

Yeah, this error message is already only emitted for directives in
macro arguments -- in this case, pr_info.  It's in sparse's
preprocessor code; the error arises when a directive is spotted while
parsing a macro's arguments.  By the time sparse (or an idealized C
compiler) parses the arguments of a real function, the token stream is
already the output of the preprocessor and any directives are gone.

Cheers,
Greg
