Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaDNMtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaDNMtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:49:01 -0400
Date: Mon, 14 Apr 2014 08:48:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in
 unstable condition
Message-ID: <20140414124854.GA928@redhat.com>
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <87d2gkxzkl.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2gkxzkl.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 10:14:18PM -0700, Eric W. Biederman wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
> > Add a "late_kdump" option to run kdump after running panic
> > notifiers and dump kmsg. This can help rare situations which
> > kdump drops in failure because of unstable crashed kernel
> > or hardware failure (memory corruption on critical data/code),
> > or the 2nd kernel is broken by the 1st kernel (it's a broken
> > behavior, but who can guarantee that the "crashed" kernel
> > works correctly?).
> >
> > Usage: add "late_kdump" to kernel boot option. That's all.
> >
> > Note that this actually increases risks of the failure of
> > kdump. This option should be set only if you worry about
> > the rare case of kdump failure rather than increasing the
> > chance of success.
> 
> This is better than some others, but every time I have seen a request
> to do this it is because someone wants to do something horrible that
> makes kdump more brittle and generally unsupportable.
> 
> You seem to in general understand that.
> 
> But how can we support an option to make the kernel flakier?
> 
> I suspect it would be more productive to work on the lkcd (spelling?)
> test module and show that crash dump actually works in the situation
> people are worried about.
> 
> Just thinking about this send shivers up my spine. Ick.

Eric,

This question has been raised many a times. Our argument has been that
it reduces kdump reliability. And their argument is that so be it. They
are ready to bear that cost and before we really transition into kdump
kernel they want to do something else. One such use case is trying to
save some information into NVRAM.

Their argument is that saving to NVRAM is more reliable. There are no
guarantees that kdump kernel will actually come and save full dump. So
they think that they can save kernel log buffers to NVRAM atleast before
jumping to kdump kernel.

I understand that this is antithesis to executing some code in crashed
kernel and it reduces the reliability of kdump operation. But I also think
we should atleast provide people with a choice. And it is up to them whether
how do they want to configure the system.

If somebody is willing to live with reduced reliability of kdump
operation, why should we enforce that no such option will be provided.

Thanks
Vivek
