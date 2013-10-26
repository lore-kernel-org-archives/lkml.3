Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3JZLQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3JZLQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:16:41 -0400
To: Pekka Enberg <penberg@kernel.org>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	<20131023050502.1886.15779.stgit@hemant-fedora>
	<CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 26 Oct 2013 07:16:05 -0400
In-Reply-To: <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> (Pekka Enberg's message of "Fri, 25 Oct 2013 14:38:17 +0200")
Message-ID: <y0mbo2cs2oa.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> writes:

> Is there a technical reason why 'perf list' could not show all the
> available SDT markers on a system and that the 'mark to event'
> mapping cannot happen automatically? [...]

A quick experiment with:

  find `echo $PATH | tr : ' '` -type f -perm -555 | 
       xargs readelf -n 2>/dev/null | 
       grep STAP 2>/dev/null 

suggests reasonable performance for my F19 workstation (a second or
two over ~6000 executables), once all the ELF content is in the block
cache.  According to a stap eventcount.stp run, that required about
50000 syscall.read events.

Note that a $PATH search excludes shared libraries, which can also
carry <sys/sdt.h> markers.  Adding /usr/lib* in more than doubles the
work, then there's /usr/libexec etc.

- FChE
