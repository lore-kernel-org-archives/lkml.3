Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaFDLbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaFDLbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:31:35 -0400
Date: Wed, 4 Jun 2014 13:31:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140604113124.GC5555@krava.brq.redhat.com>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <53872A72.6040007@hitachi.com>
 <20140603203823.GG3696@kernel.org>
 <538ED7DE.5070508@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538ED7DE.5070508@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 05:25:02PM +0900, Masami Hiramatsu wrote:
> (2014/06/04 5:38), Arnaldo Carvalho de Melo wrote:
> > Now trying to reference a bogus member name:
> > 
> > [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->BOGUS:string'
> > result(type:filename) has no member BOGUS.
> > Failed to find 'result' in this function.
> >   Error: Failed to add events. (-22)
> > [root@zoo ~]#
> > 
> > No segfault, albeit it produces a bogus error message, as it clearly
> > _finds_ the 'result' variable, its just that it is of a struct type that
> > _has_ no such 'BOGUS' _member_.
> 
> Right, I'll fix that.

should I wait for new patchset, or should I take those 2?

thanks,
jirka
