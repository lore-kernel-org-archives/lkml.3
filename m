Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbbAUOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:25:56 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:48326 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753869AbbAUOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:25:48 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:981:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12663:12740:13069:13138:13231:13255:13311:13357:13618:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: walk19_32723a7b2fd4c
X-Filterd-Recvd-Size: 2496
Date: Wed, 21 Jan 2015 09:25:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Wang Nan <wangnan0@huawei.com>, jeremie.galarneau@efficios.com,
        bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid
 reserved keywords.
Message-ID: <20150121092545.1d2623ff@gandalf.local.home>
In-Reply-To: <20150121141938.GB6835@krava.brq.redhat.com>
References: <20150120130609.GC15315@krava.brq.redhat.com>
	<1421810634-1373-1-git-send-email-wangnan0@huawei.com>
	<54BF8A97.6050402@huawei.com>
	<20150121141938.GB6835@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 15:19:38 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Jan 21, 2015 at 07:16:39PM +0800, Wang Nan wrote:
> > Hi Jiri,
> > 
> > I found that only this patch is not enough. When converting such tracepoints,
> > it uses add_tracepoint_fields_values(..., struct format_field *fields ...),
> > and fields->name is still the original one.
> > 
> > If 'struct format_field' has a field like 'dup_name' we can make things simpler.
> > However, struct format_field is part of traceevent, not only used by perf.
> > 
> > I have no enough time to think on it. Jiri, could you please give me some hints
> > so I can implement another patch tomorrow?
> 
> yea, looks like we either need to add 'void *priv' into 'struct format_field'
> or if Steven doesn't like it, we'd need to save 'our' field name in some way
> so it's reachable via format_field::name string.
> 
> Steven,
> we need to use changed format_field::name to interface babeltrace
> library, because it has restriction that fields within tracepoint
> should have unique names.
> 
> Any chance we could introduce 'void *priv' member to format_field::name ?
> Maybe with 'destroy_priv' callback to be called when the field is destroyed.
> 
> I can provide patch, just wanted to know first if you're not strictly against ;-)
> 

I'm not exactly sure what the issue is. I guess I need to see a patch
to understand better.

-- Steve
