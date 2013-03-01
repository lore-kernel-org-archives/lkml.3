Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3CAAGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:06:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3CAAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:06:08 -0500
Date: Thu, 28 Feb 2013 19:05:40 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, konrad.wilk@oracle.com,
        rostedt@goodmis.org, gregkh@linuxfoundation.org,
        samu.kallio@aberdeencloud.com, kraman@redhat.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130301000539.GA31649@hansolo.jdub.homelinux.org>
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130228233720.GB17468@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228233720.GB17468@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:37:20AM +0100, Borislav Petkov wrote:
> On Thu, Feb 28, 2013 at 05:55:49PM -0500, Boris Ostrovsky wrote:
> > Invoking arch_flush_lazy_mmu_mode() results in calls to
> > preempt_enable()/disable() which may have performance impact.
> > 
> > Since lazy MMU is not used on bare metal we can patch away
> > arch_flush_lazy_mmu_mode() so that it is never called in such
> > environment.
> > 
> > Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> 
> Looks straight-forward enough to me.
> 
> Acked-by: Borislav Petkov <bp@suse.de>

I'll try to get someone to test this tomorrow.

josh
