Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaLKSsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:48:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaLKSsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:48:50 -0500
Message-ID: <5489E6D0.8020002@zytor.com>
Date: Thu, 11 Dec 2014 10:47:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to be preempted
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <5488E552.8050207@zytor.com> <20141211010344.GO25677@wotan.suse.de>
In-Reply-To: <20141211010344.GO25677@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 05:03 PM, Luis R. Rodriguez wrote:
> 
> This is an issue onloy for for non*-preemptive kernels.
> 
> Some of Xen's hypercalls can take a long time and unfortunately for
> *non*-preemptive kernels this can be quite a bit of an issue.
> We've handled situations like this with cond_resched() before which will
> push even *non*-preemptive kernels to behave as voluntarily preemptive,
> I was not aware to what extent this was done and precedents set but
> its pretety widespread now... this then just addresses once particular
> case where this is also an issuefor but now in IRQ context.
> 
> I agree its a hack but so are all the other cond_reshed() calls then.
> I don't think its a good idea to be spreading use of something like
> this everywhere but after careful review and trying toa void this
> exact code for a while I have not been able to find any other reasonable
> alternative.
> 

This sounds like a patch that is completely unrelated to the rest of the
patch.

	-hpa


