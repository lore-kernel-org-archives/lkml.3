Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3LFPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:44:19 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:57895 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab3LFPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:44:17 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 10:44:17 EST
Date: Fri, 6 Dec 2013 15:37:13 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Oleg Nesterov <oleg@redhat.com>
cc: Tejun Heo <htejun@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
In-Reply-To: <20131206145322.GB2674@redhat.com>
Message-ID: <00000142c88e3976-f033b304-5a25-4cf3-854e-2ac02d209099-000000@email.amazonses.com>
References: <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com> <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
 <20131205143745.GA18488@redhat.com> <20131205143903.GA3231@htj.dyndns.org> <20131205153016.GA20705@redhat.com> <00000142c42d9708-c1154c9a-4265-45ee-971f-a6c8b5768ebf-000000@email.amazonses.com> <20131206145322.GB2674@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.06-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Oleg Nesterov wrote:

> This probably means that Tejun's "default attributes which are inherited
> by all workqueues" suggestion was right.

There are workqueues that are required to run on specific nodes /
processors. Those cannot inherit these attributes and would need to be
used regardless of the attributes if the kernel code demands it.



