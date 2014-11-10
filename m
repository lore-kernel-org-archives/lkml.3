Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKJMwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:52:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKJMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:50:33 -0500
Date: Mon, 10 Nov 2014 13:50:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
Message-ID: <20141110125021.GP3337@twins.programming.kicks-ass.net>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
 <20141102105557.21708.19032.stgit@hemant-fedora>
 <87lhnr5sbl.fsf@sejong.aot.lge.com>
 <54588905.7040002@linux.vnet.ibm.com>
 <5458CD15.4010101@hitachi.com>
 <874muew2hk.fsf@sejong.aot.lge.com>
 <5459E865.6050207@hitachi.com>
 <545B1DDE.9000202@linux.vnet.ibm.com>
 <545C80F4.4020905@hitachi.com>
 <CAPh34mfj5DJSbUBhQSZS_QpTUubV5a7UEsiyzfNSia3bjU2kww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPh34mfj5DJSbUBhQSZS_QpTUubV5a7UEsiyzfNSia3bjU2kww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 01:05:45PM +0100, Hagen Paul Pfeifer wrote:
> On 7 November 2014 09:21, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > File Format
> > ===========
> > All the cache files are placed under ~/.debug/ by default.
> > The paths of buildid cache of binary/symbols are not changed.
> >
> > The SDT/probe caches are placed under the ~/.debug/.probes/path/to/bin/bu/ildid
> > and that is linked to ~/.debug/.probes/.buildid/bu/ildid
> > # To avoid conflict with files under /probes/*, I picked up .probes/.
> 
> A little bit late: but why ~/.debug? Why not $XDG_CACHE_HOME/perf/ as
> the root for all perf related files? debug is not unique nor is it sufficient
> to meet file hierarchy: man file-hierarchy(8)

# env | grep XDG | wc -l
0

Which renders it useless crap in my book.

I agree on the .debug name being somewhat generic, also, it would be:
man 8 file-hierarchy, but that too fails:

$ man file-hierarchy
No manual entry for file-hierarchy


