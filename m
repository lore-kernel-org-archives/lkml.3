Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaKJMbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:31:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaKJMby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:31:54 -0500
Date: Mon, 10 Nov 2014 10:31:31 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
Message-ID: <20141110123131.GD4468@redhat.com>
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
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 10, 2014 at 01:05:45PM +0100, Hagen Paul Pfeifer escreveu:
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

Why "perf"?

> the root for all perf related files? debug is not unique nor is it sufficient

Probably should be some other name then, but ~/.debug/ is there since
the build-id cache was introduced, guess this is why it is being kept so
far in Masami's proposal.

> to meet file hierarchy: man file-hierarchy(8)

Humm,

It starts in $HOME/.debug/ because this is not supposed to be a system
wide cache, a developer can, for instance:

1. perf record myapp
2. edit myapp.c
3. rebuild it
4. perf record myapp
5. perf diff

And it will show the difference from the previous version, for which it
stored a copy of its binary on its private, keyed by build-id, cache.

So this is not merely a place where we will read stuff from.

If somebody decides to have it in a place accessible by multiple users
on the same system, then, yes, some more suitable place outside its
$HOME is needed, and then tooling should look there as well as on the
places it already looks for such files, i.e. $HOME/.debug/,
/usr/lib/debug (where foo-debuginfo packages store stuff, also keyed by
build-id), /lib/modules/$KVR/, etc.

- Arnaldo
