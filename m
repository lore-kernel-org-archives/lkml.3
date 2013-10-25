Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3JYM7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:59:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42735 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3JYM7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:59:37 -0400
Date: Fri, 25 Oct 2013 18:29:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131025125921.GA29424@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102512-5806-0000-0000-00002336F4BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

> >
> > You can now use it in all perf tools, such as:
> >
> >     perf record -e libc:my_event -aR sleep 1
> 
> Is there a technical reason why 'perf list' could not show all the
> available SDT markers on a system and that the 'market to event'
> mapping cannot happen automatically?
> 

Technically feasible. But then we would have to parse each of the
libraries and executables to list them. Right? I am not sure if such a
delay is acceptable.

Also if a binary exists in a path thats is not covered in the default
search, an user might believe that his binary may not have markers.
I know the above reason is more of a user folly than a tooling issue.

> So instead of doing all the command line magic above I'd do:
> 
>   perf list
> 
>   libc:setjmp [SDT marker]
> 
> and I could just do
> 
>   perf record -e libc:setjmp -AR sleep 1
> 
> ?

-- 
Thanks and Regards
Srikar Dronamraju

