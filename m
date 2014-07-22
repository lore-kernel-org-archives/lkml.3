Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaGVJoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:44:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaGVJo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:44:29 -0400
Date: Tue, 22 Jul 2014 11:44:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, hpa@zytor.com,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140722094425.GC6462@pd.tnic>
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140722084641.GA5730@gchen.bj.intel.com>
 <20140722093023.GA6841@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140722093023.GA6841@kernel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 05:30:23PM +0800, Wanpeng Li wrote:
> On Tue, Jul 22, 2014 at 04:46:41AM -0400, Chen, Gong wrote:
> >On Tue, Jul 22, 2014 at 04:04:52PM +0800, Wanpeng Li wrote:
> >> Subject: [PATCH v2] x86, hotplug: fix llc shared map unreleased during cpu
> >>  hotplug
> >
> >See this link:
> >https://lkml.org/lkml/2014/7/17/78
> 
> Interesting, thanks for your pointing out.

Well, we might end up doing both.

Yasuaki's patch makes the core numbering stable which makes a lot of
sense in and of itself.

However, if some code somewhere relies implicitly on the fact that a set
bit in LLC mask means that core is online and goes and does stuff on it,
Wanpeng's reported splat will happen.

So probably we will have to have *stable* core numbers *and* clear the
LLC mask in order to be on the safe side of things.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
