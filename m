Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3CKRpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:45:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CKRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:44:59 -0400
Message-ID: <1363023885.14933.16.camel@laptop>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 11 Mar 2013 18:44:45 +0100
In-Reply-To: <20130311164309.GG13679@krava.brq.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	 <1362994843.10972.40.camel@laptop>
	 <20130311112105.GA9737@krava.brq.redhat.com>
	 <1363019193.14933.14.camel@laptop>
	 <20130311164309.GG13679@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 17:43 +0100, Jiri Olsa wrote:

> I did not know there were other plans for that, seemed useless

I like to keep form, confuses me less :-)

Anyway, why are we getting to that part of perf_output_begin() if we
don't have any data pages to begin with? Shouldn't we bail before there
someplace? Like at the !rb->nr_pages check?

