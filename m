Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbbANVI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:08:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:37303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbANVI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:08:57 -0500
Date: Wed, 14 Jan 2015 18:08:52 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 1/4] perf tools: Fix segfault for symbol annotation on
 TUI
Message-ID: <20150114210852.GD3691@kernel.org>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
 <54B683ED.2060105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B683ED.2060105@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 14, 2015 at 07:57:49AM -0700, David Ahern escreveu:
> On 1/14/15 4:18 AM, Namhyung Kim wrote:
> 
> >@@ -129,8 +124,7 @@ static inline struct sym_hist *annotation__histogram(struct annotation *notes, i
> >
> >  static inline struct annotation *symbol__annotation(struct symbol *sym)
> >  {
> >-	struct sannotation *a = container_of(sym, struct sannotation, symbol);
> >-	return &a->annotation;
> >+	return (void *)sym - symbol_conf.priv_size;
> 
> symbol__priv(sym);

Amended, thanks.

- Arnaldo
