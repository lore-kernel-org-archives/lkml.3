Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaIZPf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:35:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:40886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaIZPf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:35:57 -0400
Date: Fri, 26 Sep 2014 12:35:53 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 1/2] perf callchain: Create an address space per thread
Message-ID: <20140926153553.GD3879@kernel.org>
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
 <20140923122437.GE2979@krava.brq.redhat.com>
 <CAM9d7cjY9HwRSKJvuUfbQPmi6se1H7+vONGxDTBdv=xNR-EOUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cjY9HwRSKJvuUfbQPmi6se1H7+vONGxDTBdv=xNR-EOUQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 23, 2014 at 09:49:22PM +0900, Namhyung Kim escreveu:
> On Tue, Sep 23, 2014 at 9:24 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >>               list_add(&comm->list, &thread->comm_list);
> >> +
> >> +             if (unwind__prepare_access(thread) < 0) {
> >
> > you could call list_add below this call and thus save
> > the list_del call below in error path
> >
> > looks like you dont need comm to be on comm_list within
> > the unwind__prepare_access call
> 
> Right.  Will change.

Ok, waiting for v2 then.

- Arnaldo
