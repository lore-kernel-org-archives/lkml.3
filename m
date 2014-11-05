Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaKEN2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaKEN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:28:50 -0500
Date: Wed, 5 Nov 2014 11:28:17 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        acme@kernel.org
Subject: Re: Re: Re: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record
 to trace SDT events
Message-ID: <20141105132817.GE2487@redhat.com>
References: <5458CD15.4010101@hitachi.com>
 <5459BD3E.7010804@linux.vnet.ibm.com>
 <5459C8BE.30809@linux.vnet.ibm.com>
 <5459E8BC.8030500@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5459E8BC.8030500@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 05, 2014 at 06:07:08PM +0900, Masami Hiramatsu escreveu:
> (2014/11/05 15:50), Hemant Kumar wrote:
> >> And also, user interface is a discussion point. This series defines new
> >> sdt-cache command, and we already have buildid-cache command. We should
> >> have probe-cache command too? or consolidate those cache managing 
> >> commands?
> >> This question should be involving your series too.

> > I think, we need not have multiple sub-commands to manage the cache. We 
> > can consolidate the cache management of probe events (including SDT 
> > events) to a single command.

> Agreed. maybe perf-cache --buildid/--sdt/--probe would be good.

We have it already, its called 'perf buildid-cache':

[root@zoo ~]# perf buildid-cache --hell
  Error: unknown option `hell'

 usage: perf buildid-cache [<options>]

    -a, --add <file list>
                          file(s) to add
    -k, --kcore <file>    kcore file to add
    -r, --remove <file list>
                          file(s) to remove
    -M, --missing <file>  to find missing build ids in the cache
    -f, --force           don't complain, do it
    -u, --update <file list>
                          file(s) to update
    -v, --verbose         be more verbose

[root@zoo ~]#

We can rename it at some point to 'perf cache', perhaps.

'perf cache --buildid'  makes no sense, everything is keyed by build-id
(hence the name, which is albeit long, admit), I guess what you meant
was 'elf'.

It currently stores content of the form:

- ELF
- kcore (which is also ELF, but has no pathname)
- kallsyms

We would be adding other types of content, from this discussion:

- sdt
- [ku]probes (built from some other content, like ELF or kallsyms)
 
- Arnaldo
