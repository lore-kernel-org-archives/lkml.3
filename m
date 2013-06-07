Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FGNr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:47:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37222 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3FGNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:47:28 -0400
Date: Fri, 7 Jun 2013 15:47:16 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Message-ID: <20130607134716.GG3886@rric.localhost>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-17-git-send-email-rric@kernel.org>
 <20130603134925.GA13548@krava.brq.redhat.com>
 <20130604082042.GB23640@pd.tnic>
 <20130604091921.GC1103@krava.brq.redhat.com>
 <20130604093522.GD23640@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604093522.GD23640@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.06.13 11:35:22, Borislav Petkov wrote:
> On Tue, Jun 04, 2013 at 11:19:21AM +0200, Jiri Olsa wrote:
> > 'cpu' did not pass ay check here..
> 
> Oh, I see.
> 
> You mean something like
> 
> 	if (cpu < NR_CPUS && cpu_online(cpu))

In perf_event_alloc() there is:

        if ((unsigned)cpu >= nr_cpu_ids) {
                if (!task || cpu != -1)
                        return ERR_PTR(-EINVAL);
        }

So this should be sufficient:

	if ((unsigned)cpu >= nr_cpu_ids)
		...

-Robert
