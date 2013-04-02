Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3DBTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab3DBTLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:11:40 -0400
Date: Tue, 2 Apr 2013 15:11:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130402191130.GB31760@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
 <1364923183-316-4-git-send-email-yinghai@kernel.org>
 <20130402180606.GI29506@redhat.com>
 <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
 <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:49:13AM -0700, Yinghai Lu wrote:
> On Tue, Apr 2, 2013 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > aka:
> > old kexec-tools stay with "crashkernel=X"
> > new kexec-tools stay with
> > 1. like old kexec tools
> > 2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
> > Y could be 100M or 0 etc.
> 
> I keep the old logic like:
> if there are several "crashkernel=X,high", only last one is honored.
> if there are several "crashkernel=Y,low", only last one is honored.

Yes but if different types of crashkernel= options are mixes then
behavior is not defined.

crashkernel=X,high crashkernel=X
crashkernel=X,high crashkernel=Y;low
crashkernel=Y;low crashkernel=X

And possibilities go on. So I think it makes life simpler if we always
parse last crashkernel= option and act upon that. And use
crashkernel_no_auto_low to opt out of auto reserved low memory area.

Thanks
Vivek
