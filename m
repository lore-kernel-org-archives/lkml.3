Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3KKNBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:01:33 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:62329 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KKNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:01:24 -0500
Date: Mon, 11 Nov 2013 14:01:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131111130116.GA26853@localhost.localdomain>
References: <874n7w4gtm.fsf@sejong.aot.lge.com>
 <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
 <20131106121038.GA7919@localhost.localdomain>
 <20131111121212.GA21397@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111121212.GA21397@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 01:12:12PM +0100, Ingo Molnar wrote:
> > I'm not sure why you want to add a new -F that adds news way to display 
> > fields. Isn't -s enough for that?
> 
> Well, -s implies sorting.
> 
> With -F we could decouple sorting from display order, and allow output 
> like:
> 
>   # Symbol   Command    Shared Object   Overhead
> 
> Where we still sort by 'overhead', yet display things by having 'overhead' 
> last.
> 
> So basically have maximum flexibility of output and sorting - into which 
> the new 'total' field for accumulated stats would fit automatically.

Ok, I haven't followed the details on why we want this to display the cumulated
overhead.

But reordering the columns should be ok as long as we have the same fields present in -F and -s.
