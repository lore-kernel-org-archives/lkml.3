Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaJVRrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:47:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44279 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJVRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:47:39 -0400
Date: Wed, 22 Oct 2014 10:46:59 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141022174659.GA5119@us.ibm.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
 <20141022081730.GB9860@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022081730.GB9860@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102217-0033-0000-0000-0000026BCF26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| > +			goto out;
| > +		}
| > +		dso->dwfl = dwfl;
| 
| so by this we get powerpc arch code sharing dw handle via dso object,
| but we have lot of generic code too ;-)

Well, this applies to powerpc...

| 
| could you make this happen for unwind__get_entries.. probably
| both sharing same generic code I guess

and unwind_get_entries() applies only to x86 and arm right ? ;-)
Or at least thats what the config/Makefile says.

I can take a look at unwind_get_entries(), but can you please merge
this fix for now, since the current performance is bad?

| 
| thanks,
| jirka

