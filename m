Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaDVTJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbaDVTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:09:42 -0400
Date: Tue, 22 Apr 2014 15:09:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com
Subject: Re: [PATCH 0/4 V3] Print traces on softlockup
Message-ID: <20140422190935.GL8488@redhat.com>
References: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
 <20140422112828.ea511cefa17affb99d9aa97f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422112828.ea511cefa17affb99d9aa97f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:28:28AM -0700, Andrew Morton wrote:
> On Tue, 22 Apr 2014 11:17:24 -0400 Don Zickus <dzickus@redhat.com> wrote:
> 
> > Added more patches to handle the 'uniprocessor' panic case by sending NMIs
> > to every cpu but self.  Only affects x86, sparc.
> > 
> 
> Looks OK to me.  A couple of things:
> 
> - Patches 1-3 should be combined so we don't create bisection holes
>   due to x86 and sparc build errors.

ok.

> 
> - Patch 4 adds stuff which is unusable on uniprocessor, especially
>   the presence of /proc/sys/kernel/softlockup_all_cpu_backtrace.  We
>   already have #ifdef CONFIG_SMP in kern_table, so do more of that?

I can resubmit that patch with CONFIG_SMP around each piece of that patch.

Thanks for the review.

Cheers,
Don
