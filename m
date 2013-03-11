Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3CKSDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKSDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:03:04 -0400
Date: Mon, 11 Mar 2013 19:02:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
Message-ID: <20130311180229.GI13679@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
 <1362994843.10972.40.camel@laptop>
 <20130311112105.GA9737@krava.brq.redhat.com>
 <1363019193.14933.14.camel@laptop>
 <20130311164309.GG13679@krava.brq.redhat.com>
 <1363023885.14933.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363023885.14933.16.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:44:45PM +0100, Peter Zijlstra wrote:
> On Mon, 2013-03-11 at 17:43 +0100, Jiri Olsa wrote:
> 
> > I did not know there were other plans for that, seemed useless
> 
> I like to keep form, confuses me less :-)

ook

> 
> Anyway, why are we getting to that part of perf_output_begin() if we
> don't have any data pages to begin with? Shouldn't we bail before there
> someplace? Like at the !rb->nr_pages check?
> 

perf_output_begin actually does the !rb->nr_pages check
looks like we could check it earlier in some casese, I'll
update my todo list ;-)

jirka
