Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3GQPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:31:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3GQPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:31:35 -0400
Date: Wed, 17 Jul 2013 12:31:18 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] perf tools: Fix 'make tools/perf'
Message-ID: <20130717153118.GC2071@ghostprotocols.net>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
 <20130716145036.GH8731@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716145036.GH8731@rric.localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 16, 2013 at 04:50:36PM +0200, Robert Richter escreveu:
> There are other variant of building perf too:
> 
>  $ make -C tools perf
>  $ make -C tools/perf
> 
> Plus variants with O= and DESTDIR set.
> 
> This patch fixes the above and was tested with the following:
> 
>  $ make O=... DESTDIR=... tools/perf
>  $ make O=... DESTDIR=... -C tools/ perf
>  $ make O=... DESTDIR=... -C tools/perf
>  $ make tools/perf
>  $ make -C tools/ perf
>  $ make -C tools/perf

Thanks, those work now, applied, but can you check all those with actual
targets at the end, i.e. like:


make tools/perf install

Humm, probably it will look at the top level 'install' target? There was
some discussion about this, right? Can you refresh my mind?

- Arnaldo
