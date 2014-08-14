Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaHNA0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:26:52 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50179 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaHNA0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140813093613.GB2775@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
	<1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
	<20140812120905.GB7049@dhcp22.suse.cz>
	<CAM_iQpWV8DRGBQ-Brz=_Nqen0fNPDk+6kn_Og3HnXnujmgA+JA@mail.gmail.com>
	<20140813093613.GB2775@dhcp22.suse.cz>
Date: Wed, 13 Aug 2014 17:26:48 -0700
Message-ID: <CAM_iQpX2J8E_N0t5bxBVF_rO_FiFujKuXFMLg47fgL580u+gGw@mail.gmail.com>
Subject: Re: [Patch] x86,mm: check freeze request in page fault handler
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 2:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 12-08-14 17:47:02, Cong Wang wrote:
> [...]
>> Does the following updated patch make any sense to you? If not, I will just
>> drop it.
>
> Not really to be honest. I do not see what problem you are trying to fix.
>

In my case, a page faulted process triggered OOM, kernel kept
retrying this fault since without my fix oom killer couldn't kill a
frozen process.
This led to that this process is always running even after we tried to
freeze it,
the whole memory cgroup just stayed in FREEZING state.

Although with my fix, OOM will kill the frozen process so that the page faulted
process could probably stop retrying the fault finally, the question
is that is OOM
the only case blocks page fault? Looking at the code, there could be other case
blocking page fault handler as well, so instead of keep retrying for
unknown times
with ignoring freeze request, why not just freeze it since this is not
dangerous?

Or I am missing anything?
