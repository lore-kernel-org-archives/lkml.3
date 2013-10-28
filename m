Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3J1O0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:26:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44401 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab3J1O0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:26:42 -0400
Date: Mon, 28 Oct 2013 19:41:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131028141152.GA1040@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <526E4940.8000608@hitachi.com>
 <526E5BA5.7050103@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <526E5BA5.7050103@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102814-5806-0000-0000-0000233CB0F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@iki.fi> [2013-10-28 14:42:13]:

> >So, it still needs a concrete binary path to list or, we should
> >support a syntax which specify actual binary, as like as below.
> >
> >  perf probe 'my_event=%libc:setjmp@/lib64/libc.so.6'
> >
> >And perf list may show the marker as in same syntax (for copy&paste).
> >
> ># perf list --sdt
> >  %libc:setjmp@/lib64/libc.so.6
> >  ...
> >
> >Note that we need '%' to separate namespace :(, since user can define
> >any marker(provider) name in their binary...
> 
> Sure, you need to support that sort of 'fully qualified name' for
> duplicate symbols but the default 'libc:setjmp' should still point
> to system libc.

But what if a system has both 32 bit libc and 64 bit libc?
Wont we could end up with 2 libc:setjmp? 
Should we give some more intelligence into perf to choose the 64 bit
libc over 32 bit one?

-- 
Thanks and Regards
Srikar Dronamraju

