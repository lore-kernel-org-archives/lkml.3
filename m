Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3IERiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:38:22 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:56912 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3IERiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:38:21 -0400
Date: Thu, 5 Sep 2013 18:35:39 +0100
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Clarify error when running "perf lock record"
Message-ID: <20130905173538.GB31659@sdfg.com.ar>
References: <1378369936-26473-1-git-send-email-rodrigo@sdfg.com.ar>
 <52289536.3070504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52289536.3070504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:29:10AM -0600, David Ahern wrote:
> On 9/5/13 2:32 AM, Rodrigo Campos wrote:
> >If you have the config options enabled in your kernel, you still need to be root
> >to run perf lock. And is kind of misleading when you have that options enabled
> >and the error says that they might not be.
> >
> >So, this patch just adds to the error that it should be run as root. Although we
> >can probably check if it's running as root or not, adding it to the error
> >message is really simple and should be enough.
> >
> >Signed-off-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
> >---
> >Please keep me in Cc: since I'm not subscribed
> >---
> >  tools/perf/builtin-lock.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> >index 76543a4..f07b318 100644
> >--- a/tools/perf/builtin-lock.c
> >+++ b/tools/perf/builtin-lock.c
> >@@ -886,8 +886,8 @@ static int __cmd_record(int argc, const char **argv)
> >  	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
> >  		if (!is_valid_tracepoint(lock_tracepoints[i].name)) {
> >  				pr_err("tracepoint %s is not enabled. "
> >-				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?\n",
> >-				       lock_tracepoints[i].name);
> >+				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled "
> >+				       "and running as root?\n", lock_tracepoints[i].name);
> >  				return 1;
> >  		}
> >  	}
> >
> 
> you can run perf-lock as non-root with certain settings. It would be

Ohh, I didn't know. Sorry.

> better to discriminate debugfs access errors (insufficient
> privilege). That means improving is_valid_tracepoint and handling
> the errors in perf-lock.

IMHO suggesting to check the privileges should be enough for most cases and is
simpler that checking all that. I mean, for me it's not worth the effort, but
maybe I'm too lazy. Probably it's quite simple too... :-)




Thanks,
Rodrigo
