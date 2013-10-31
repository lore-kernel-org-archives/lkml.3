Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3JaXbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:31:39 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:52653 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761Ab3JaXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:31:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:3874:4321:4384:4389:4395:5007:7514:7652:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: train15_255a2564e0744
X-Filterd-Recvd-Size: 2318
Message-ID: <1383262255.2769.11.camel@joe-AO722>
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter
 files/functions/modules
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Du, Changbin" <changbin.du@gmail.com>, jbaron@akamai.com,
        linux-kernel@vger.kernel.org
Date: Thu, 31 Oct 2013 16:30:55 -0700
In-Reply-To: <20131031155253.79a21d6a126be11a64153d8b@linux-foundation.org>
References: <51F73A17.2090208@akamai.com>
	 <1382974150-7392-1-git-send-email-changbin.du@gmail.com>
	 <20131031155253.79a21d6a126be11a64153d8b@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-31 at 15:52 -0700, Andrew Morton wrote:
> On Mon, 28 Oct 2013 23:29:10 +0800 "Du, Changbin" <changbin.du@gmail.com> wrote:
[]
> > +/* check if the string matches given pattern which includes wildcards */
> > +static int match_pattern(const char *pattern, const char *string)
[]
> No, something like this should be in lib/ so that other callers can use
> it.  We already have at least one copy handy in
> drivers/ata/libata-core.c:glob_match().  A better approach would be to
> move that glob_match() into lib/glob_match.c then teach dynamic_debug
> to use it.
> 
> There are probably other private globbing functions lying around the
> kernel, but it's rather a hard thing to grep for...

Maybe use lib/parser.c where the other match_<foo> functions
are already.

match_glob has the disadvantage that it's recursive too.

trace has:

kernel/trace/trace_events_filter.c:static int regex_match_full(char *str, struct regex *r, int len)
kernel/trace/trace_events_filter.c:static int regex_match_front(char *str, struct regex *r, int len)
kernel/trace/trace_events_filter.c:static int regex_match_middle(char *str, struct regex *r, int len)
kernel/trace/trace_events_filter.c:static int regex_match_end(char *str, struct regex *r, int len)

but there probably aren't many more that could be converted.

