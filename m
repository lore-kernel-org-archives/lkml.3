Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbaLKUj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:39:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330AbaLKUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:39:24 -0500
Date: Thu, 11 Dec 2014 21:39:21 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to be
	preempted
Message-ID: <20141211203921.GP25677@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <5488E552.8050207@zytor.com> <20141211010344.GO25677@wotan.suse.de> <5489E6D0.8020002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489E6D0.8020002@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:47:44AM -0800, H. Peter Anvin wrote:
> On 12/10/2014 05:03 PM, Luis R. Rodriguez wrote:
> > 
> > This is an issue onloy for for non*-preemptive kernels.
> > 
> > Some of Xen's hypercalls can take a long time and unfortunately for
> > *non*-preemptive kernels this can be quite a bit of an issue.
> > We've handled situations like this with cond_resched() before which will
> > push even *non*-preemptive kernels to behave as voluntarily preemptive,
> > I was not aware to what extent this was done and precedents set but
> > its pretety widespread now... this then just addresses once particular
> > case where this is also an issuefor but now in IRQ context.
> > 
> > I agree its a hack but so are all the other cond_reshed() calls then.
> > I don't think its a good idea to be spreading use of something like
> > this everywhere but after careful review and trying toa void this
> > exact code for a while I have not been able to find any other reasonable
> > alternative.
> > 
> 
> This sounds like a patch that is completely unrelated to the rest of the
> patch.

If you mean architecture and design then yes however this patch tries
to look for a resolution with the existing architecture.

  Luis
