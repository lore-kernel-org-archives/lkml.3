Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3LLO6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:58:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37594 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3LLO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:58:15 -0500
Date: Thu, 12 Dec 2013 11:57:57 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/38] perf tools: Use asprintf instead of malloc plus
 snprintf
Message-ID: <20131212145757.GB8164@ghostprotocols.net>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <1386187622-2928-2-git-send-email-acme@infradead.org>
 <20131211221650.GP22695@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211221650.GP22695@tassilo.jf.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 02:16:50PM -0800, Andi Kleen escreveu:
> On Wed, Dec 04, 2013 at 05:06:25PM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > The asprintf library function is equivalent to malloc plus snprintf so
> > use it because it is simpler.
> 
> I used to be very fond of asprintf too, but apparently there are some 
> really ancient glibc versions that implement it incorrectly.
> I had to remove it from mcelog at some point because of that.
> 
> No need to yank it out, but just to let you know.

Can you point me to some specific glibc version where this happens? So
that we can write a feature test and if this problem is detected, then
we can provide a simple malloc + snprintf alternative that works as
expected.

- Arnaldo
