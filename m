Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3KAPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:16:26 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:41311 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KAPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:16:25 -0400
Date: Fri, 1 Nov 2013 15:16:00 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 08/14] perf report: Cache cumulative callchains
Message-ID: <20131101151600.GA3919@sdfg.com.ar>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-9-git-send-email-namhyung@kernel.org>
 <20131031111333.GB27863@sdfg.com.ar>
 <87r4b04n2t.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4b04n2t.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:07:22PM +0900, Namhyung Kim wrote:
> Hi Rodrigo,
> 
> On Thu, 31 Oct 2013 11:13:34 +0000, Rodrigo Campos wrote:
> > On Thu, Oct 31, 2013 at 03:56:10PM +0900, Namhyung Kim wrote:
> 
> I think the right fix is assigning "iter->priv = NULL" as you said.  But
> I changed this patch a bit for v3 so need to check it again.

Btw, that would have a race condition if this is run on multiple threads (I
mean, if different threads can free the same "iter->prev" pointer), at least if
we do it just assigning NULL after the free(). But maybe that's not an issue ?





Thanks a lot,
Rodrigo
