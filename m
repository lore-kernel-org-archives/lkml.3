Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3GRMq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:46:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab3GRMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:46:25 -0400
Date: Thu, 18 Jul 2013 14:46:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 02/23] perf tools: Remove data_offset seek as it's not
 needed
Message-ID: <20130718124601.GC1092@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-3-git-send-email-jolsa@redhat.com>
 <87li54wcng.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li54wcng.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:27:47PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:42 +0200, Jiri Olsa wrote:
> > Removing data_offset seek as it's not needed, because
> > data are not read by syscall but mmaped instead.
> 
> Yes we do, but it's not mandatory, right?  I'd rather expect the file
> offset remains at the beginning of data after calling
> perf_session__read_header() instead of a random point (EOF?).

well it's just useless, and I think it's better and more clear
to set it properly before the reading anyway. Also AFAICS there's
no other read after this seek even later.

jirka
