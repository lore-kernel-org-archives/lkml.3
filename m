Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbaEMPGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:06:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40000 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbaEMPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:06:21 -0400
Date: Tue, 13 May 2014 17:06:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: xiakaixu <xiakaixu@huawei.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, a.p.zijlstra@chello.nl,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Huxinwei <huxinwei@huawei.com>, peifeiyue@huawei.com
Subject: Re: Does perf support different length of user-space hw_breakpoint?
Message-ID: <20140513150613.GC13828@localhost.localdomain>
References: <53707DD6.2000108@huawei.com>
 <20140513120046.GB1138@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513120046.GB1138@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 02:00:46PM +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:52:54PM +0800, xiakaixu wrote:
> > Hi guys,
> > 
> > Does perf support different length of user-space hw_breakpoint,
> > such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
> > HW_BREAKPOINT_LEN_8?
> > 
> > Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
> > by default from the source code and simple test.
> 
> right..
> 
>         /*
>          * We should find a nice way to override the access length
>          * Provide some defaults for now
>          */
>         if (attr.bp_type == HW_BREAKPOINT_X)
>                 attr.bp_len = sizeof(long);
>         else
>                 attr.bp_len = HW_BREAKPOINT_LEN_4;
> 
> > 
> > May I have your opinions if I want to trace different bytes of
> > hw_breakpoint addr?
> 
> I guess that depends on what you want to do ;-)

Ah, I have a patchset from Jacob Shin and Suravee Suthikulpanit that does
that. Also it has been hanging around for too long by my fault. I'm posting
it now.
