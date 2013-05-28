Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366Ab3E1OiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934311Ab3E1OiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:38:24 -0400
Date: Tue, 28 May 2013 10:37:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
Message-ID: <20130528143756.GD7088@redhat.com>
References: <51A02E50.5020507@gmail.com>
 <87mwri8wwu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwri8wwu.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 04:25:21PM -0700, Eric W. Biederman wrote:
> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
> 
> > /dev/oldmem provides the interface for us to access the "old memory" in
> > the dump-capture kernel. Unfortunately, no one actually uses this interface.
> >
> > And this interface could actually cause some real problems if used on ia64
> > where the cached/uncached accesses are mixed. See the discussion from
> > the link: https://lkml.org/lkml/2013/4/12/386.
> >
> > So Eric suggested that we should remove /dev/oldmem as an unused piece of
> > code.
> >
> > Besides, we used a global variable saved_max_pfn to let the capture kernel
> > know the amount of memory that the previous kernel used. And for almost all
> > architectures (except x86. In x86, saved_max_pfn is used by detect_calgary()),
> > the only user of this variable is the read_oldmem interface of /dev/oldmem, so
> > also remove the setting for saved_max_pfn in those architectures.
> 
> Except for the devices.txt update.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric,

Should we schedule the removal of this interface after 1-2 releases
and give a warning once if anybody opens /dev/oldmem and tell them
to use /proc/vmcore instead? 

I am kind of inclined towards warning approarch. If there is any xyz
/dev/oldmem user in the wild out there, he/she atleast gets a chance to
migrate to /proc/vmcore.

Thanks
Vivek
