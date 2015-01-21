Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbbAURcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:32:21 -0500
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:56235 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751546AbbAURcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:32:12 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2197:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3872:4321:4605:5007:6261:7875:7903:9040:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paste04_4ce2c3d9f4b3a
X-Filterd-Recvd-Size: 1866
Date: Wed, 21 Jan 2015 12:32:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/5] tracing: Convert the tracing facility over to
 use tracefs
Message-ID: <20150121123207.3f1c38fc@gandalf.local.home>
In-Reply-To: <20150121172101.652881523@goodmis.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121172101.652881523@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 12:19:55 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

>  scripts/tags.sh                      |  2 +-
>  9 files changed, 81 insertions(+), 69 deletions(-)
> 


> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index cdb491d84503..505231a09b07 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -228,7 +228,7 @@ exuberant()
>  
>  emacs()
>  {
> -	all_target_sources | xargs $1 -a                        \
> +	all_target_sources | xargs $1 -a --no-members           \
>  	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
>  	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
>  	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \

Oops! I applied my "fix make tags" patch to do a new "make TAGS" and
forgot to remove it when doing the "git commit -a -s".

Will remove this from the series.

-- Steve

