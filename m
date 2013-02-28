Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3B1Xhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:37:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47737 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3B1Xha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:37:30 -0500
Date: Fri, 1 Mar 2013 00:37:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130228233720.GB17468@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, hpa@zytor.com,
	mingo@redhat.com, tglx@linutronix.de, konrad.wilk@oracle.com,
	rostedt@goodmis.org, gregkh@linuxfoundation.org,
	samu.kallio@aberdeencloud.com, kraman@redhat.com,
	jwboyer@redhat.com, xen-devel@lists.xen.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 05:55:49PM -0500, Boris Ostrovsky wrote:
> Invoking arch_flush_lazy_mmu_mode() results in calls to
> preempt_enable()/disable() which may have performance impact.
> 
> Since lazy MMU is not used on bare metal we can patch away
> arch_flush_lazy_mmu_mode() so that it is never called in such
> environment.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Looks straight-forward enough to me.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
