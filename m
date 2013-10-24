Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3JXTiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab3JXTiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:38:01 -0400
Date: Thu, 24 Oct 2013 15:37:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131024193730.GH2322@redhat.com>
References: <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
 <20131018123837.GB2277@redhat.com>
 <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
 <20131021151643.GA20669@redhat.com>
 <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
 <20131024140241.GA2322@redhat.com>
 <CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
 <20131024191821.GE2322@redhat.com>
 <CAE9FiQU7+FRY=3ETdGZJJfcS0vjRht4ZT8MHTQ66kpjD2MmrcA@mail.gmail.com>
 <20131024192752.GG2322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024192752.GG2322@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 03:27:52PM -0400, Vivek Goyal wrote:
> On Thu, Oct 24, 2013 at 12:24:57PM -0700, Yinghai Lu wrote:
> > On Thu, Oct 24, 2013 at 12:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Oct 24, 2013 at 12:15:25PM -0700, Yinghai Lu wrote:
> > >
> > > Also keeping things simple by not trying to *impose* a new crashkernel=
> > > syntax on existing crashkernel=xM users.
> > 
> > Existing user that have crashkernel=xM working with their old kernel
> > and old kexec-tools, they still could keep their old command line and
> > old kexec-tools
> > with new updated kernel.
> > We should not change semantics to surprise them.
> 
> Old users will get reservation still below 896MB.
> 
> It will go above 896MB only if memory could not be allocated below 896MB.
> 
> In the past reservation will fail and kexec-tools will fail.
> Now reservation will succeed but kexec-tools will fail.

Only corner case I can see is where memory is reserved higher, old kexec-tools
is not smart enough to figure out in advance that kernel will not boot
at this high address and still goes ahead and loads the kernel and crash
dump fails at run time.

But this will happen only if memory reservation below 896MB fails. And
in most of the cases after kernel upgrade, memory should still come
from memory region below 896MB.

Thanks
Vivek
