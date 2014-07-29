Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaG2IeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:34:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39860 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaG2IeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:34:06 -0400
Date: Tue, 29 Jul 2014 10:33:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Yong Wang <yong.y.wang@linux.intel.com>
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140729083359.GA11179@pd.tnic>
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
 <53CF78A7.5070302@jp.fujitsu.com>
 <20140729070626.GA9635@kernel>
 <53D74DD2.6040306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53D74DD2.6040306@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:31:30PM +0900, Yasuaki Ishimatsu wrote:
> >>I posted a latest patch as follows:
> >>https://lkml.org/lkml/2014/7/22/1018
> >>
> >>Could you confirm the patch fixes your issue?
> >
> >Sorry for the late, there is still call trace w/ your patch applied. The
> >call trace is in attachment.
> 
> Thank you for reporting the result. As Borislav said, your v2 patch
> is necessary for fixing your issue.

..

> >>>Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Ok, Wanpeng, please send a cleaner version of your patch with a
simplified backtrace in it - the addresses will make no sense anyway so
you can do this:

Call Trace:
load_balance
? _raw_spin_unlock_irqrestore
idle_balance
...

so that we can still see how it happens.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
