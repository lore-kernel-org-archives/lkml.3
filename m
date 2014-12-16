Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaLPRQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:16:51 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:53288 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaLPRQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:16:50 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 16 Dec 2014 12:17:10 -0500 (EST)
To: eranian@gmail.com
cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [perf tool] cgroup support broken on Debian?
In-Reply-To: <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu> <20141215220150.GP9845@kernel.org> <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014, Stephane Eranian wrote:
> On Mon, Dec 15, 2014 at 11:01 PM, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:

> fs is visible. The cgroup file system type is not there anymore. They are using
> tmpfs which is not ideal to detect just cgroup. Looks like now, we have to look
> at the mount point which is flaky.

The trivial fix is to just always assume things will be under
	/sys/fs/cgroup
which looks like to be the new official mount point.

This will break on older systems though, or systems that mount cgroupfs in 
multiple locations.

Another alternative is to change the interface to require the full 
cgroupfs pathname as an argument to -G

> Yes, the error needs to be improved or even added. The following common
> errors are encountered:
> 
> - -G option requires -a (system-wide), otherwise it does not work at all
> - -G option must always be specified AFTER the ALL event list
> - -G and explicit event groups is not well supported by the tool yet.
> An event group must have the same cgroup.
> - Cgroups are specified per event
> - -G cgroup order follows the event order: -e e1, e2, e3 -G g1,g2,g3:
> g1->e1, g2->e2, g3->e3
> - It is possible to indicate no cgroup with -G: -e e1,e2,e3 -G g1,,g3
> using empty group (,,)

I'll see if I can get a patch together that impements this.

Vince
