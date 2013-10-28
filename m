Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3J1KeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:34:08 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59458 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3J1KeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:34:06 -0400
Date: Mon, 28 Oct 2013 11:34:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@iki.fi>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131028103402.GB6274@gmail.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <y0mbo2cs2oa.fsf@fche.csb>
 <526E2304.1000407@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E2304.1000407@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@iki.fi> wrote:

> On 10/26/2013 02:16 PM, Frank Ch. Eigler wrote:
> >Pekka Enberg <penberg@kernel.org> writes:
> >
> >>Is there a technical reason why 'perf list' could not show all the
> >>available SDT markers on a system and that the 'mark to event'
> >>mapping cannot happen automatically? [...]
> >A quick experiment with:
> >
> >   find `echo $PATH | tr : ' '` -type f -perm -555 |
> >        xargs readelf -n 2>/dev/null |
> >        grep STAP 2>/dev/null
> >
> >suggests reasonable performance for my F19 workstation (a second or
> >two over ~6000 executables), once all the ELF content is in the block
> >cache.  According to a stap eventcount.stp run, that required about
> >50000 syscall.read events.
> >
> >Note that a $PATH search excludes shared libraries, which can also
> >carry <sys/sdt.h> markers.  Adding /usr/lib* in more than doubles the
> >work, then there's /usr/libexec etc.
> 
> Thanks for providing numbers to the discussion. AFAICT, we might 
> even be able to just scan everything for 'perf list' by default.

That should definitely be better in the long run than any whitelist 
(or no list at all).

Thanks,

	Ingo
