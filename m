Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbAOAWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:22:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54120 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbAOAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:22:48 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 15 Jan 2015 09:20:21 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 1/4] perf tools: Fix segfault for symbol annotation on
 TUI
Message-ID: <20150115002021.GA2096@sejong>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
 <54B683ED.2060105@gmail.com>
 <20150114210852.GD3691@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150114210852.GD3691@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and David,

On Wed, Jan 14, 2015 at 06:08:52PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 14, 2015 at 07:57:49AM -0700, David Ahern escreveu:
> > On 1/14/15 4:18 AM, Namhyung Kim wrote:
> > 
> > >@@ -129,8 +124,7 @@ static inline struct sym_hist *annotation__histogram(struct annotation *notes, i
> > >
> > >  static inline struct annotation *symbol__annotation(struct symbol *sym)
> > >  {
> > >-	struct sannotation *a = container_of(sym, struct sannotation, symbol);
> > >-	return &a->annotation;
> > >+	return (void *)sym - symbol_conf.priv_size;
> > 
> > symbol__priv(sym);
> 
> Amended, thanks.

Oh, I missed that.  Thanks to both of you!
Namhyung
