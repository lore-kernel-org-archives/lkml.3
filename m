Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3JXTS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab3JXTS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:18:57 -0400
Date: Thu, 24 Oct 2013 15:18:21 -0400
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
Message-ID: <20131024191821.GE2322@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
 <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
 <20131015144810.GI31215@redhat.com>
 <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
 <20131018123837.GB2277@redhat.com>
 <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
 <20131021151643.GA20669@redhat.com>
 <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
 <20131024140241.GA2322@redhat.com>
 <CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:15:25PM -0700, Yinghai Lu wrote:
> On Thu, Oct 24, 2013 at 7:02 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Oct 23, 2013 at 11:11:51PM -0700, Yinghai Lu wrote:
> >
> > Hence both crashkernel=xM and crashkernel=XM,high have their own usage.
> > We have been using crashkernel=xM and we know it works. So extending it
> > to be able to allocate memory from higher regions, if sufficient memory
> > is not available in lower regions makes sense. Memory reservation below
> > 4G is more efficient due to not requiring swiotlb. And crashkernel=xM
> > has been working for us and users are familiar with it.
> >
> > So I don't see a point that why would you try to block any move to
> > extend crashkernel=xM semantics.
> 
> Make the thing simple.
> Keep them separately, leave crashkernel=xM to old kexec-tools mostly
> and keep crashkernel=xM,high to newer kexec-tools as needed.

I am keeping things simple by making sure that both old kexec-tools and
new kexec-tools can use crashkernel=xM and one does not have to choose
between two based on what kexec-tools version you are using.

Also keeping things simple by not trying to *impose* a new crashkernel=
syntax on existing crashkernel=xM users.

Hence extending the semantics of crashkernel=xM makes sense to me.

Thanks
Vivek
