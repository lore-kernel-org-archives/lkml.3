Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3A2LxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:53:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46353 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3A2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:53:21 -0500
X-AuditID: 85900ec0-d687bb900000152f-7a-5107b82ec6b0
Message-ID: <5107B82E.4020403@hitachi.com>
Date: Tue, 29 Jan 2013 20:53:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH 10/25] kprobes: fix wait_for_kprobe_optimizer()
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <1356141435-17340-11-git-send-email-tj@kernel.org> <50D922C9.3020706@hitachi.com> <20130128194949.GJ22465@mtj.dyndns.org>
In-Reply-To: <20130128194949.GJ22465@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/29 4:49), Tejun Heo wrote:
> On Tue, Dec 25, 2012 at 12:51:37PM +0900, Masami Hiramatsu wrote:
>> (2012/12/22 10:57), Tejun Heo wrote:
>>> wait_for_kprobe_optimizer() seems largely broken.  It uses
>>> optimizer_comp which is never re-initialized, so
>>> wait_for_kprobe_optimizer() will never wait for anything once
>>> kprobe_optimizer() finishes all pending jobs for the first time.
>>
>> Thank you for fixing that!
>> I must misunderstand that the DECLARE_COMPLETION() macro.
>>
>>> Also, aside from completion, delayed_work_pending() is %false once
>>> kprobe_optimizer() starts execution and wait_for_kprobe_optimizer()
>>> won't wait for it.
>>>
>>> Reimplement it so that it flushes optimizing_work until
>>> [un]optimizing_lists are empty.  Note that this also makes
>>> optimizing_work execute immediately if someone's waiting for it, which
>>> is the nicer behavior.
>>
>> I think your enhancement is reasonable and GOOD for me.
>>
>> Thanks again!
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Can I take it through workqueue branch w/ other patches?

Yes, of course. I think it is not a critical bug, so I can
wait for other patches.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


