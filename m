Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbaKTRjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:39:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbaKTRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:39:12 -0500
Date: Thu, 20 Nov 2014 18:38:33 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: zhanghailiang <zhang.zhanghailiang@huawei.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 00/17] RFC: userfault v2
Message-ID: <20141120173833.GG803@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <545221A4.9030606@huawei.com>
 <20141030124950.GJ2376@work-vm>
 <5452E531.4070205@huawei.com>
 <20141119184938.GE803@redhat.com>
 <546D57E5.3080803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D57E5.3080803@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 20, 2014 at 10:54:29AM +0800, zhanghailiang wrote:
> Yes, you are right. This is what i really want, bypass all non-present faults
> and only track strict wrprotect faults. ;)
> 
> So, do you plan to support that in the userfault API?

Yes I think it's good idea to support wrprotect/COW faults too.

I just wanted to understand if there was any other reason why you
needed only wrprotect faults, because the non-present faults didn't
look like a big performance concern if they triggered in addition to
wrprotect faults, but it's certainly ok to optimize them away so it's
fully optimal.

All it takes to differentiate the behavior should be one more bit
during registration so you can select non-present, wrprotect faults or
both. postcopy live migration would select only non-present faults,
postcopy live snapshot would select only wrprotect faults, anything
like distributed shared memory supporting shared readonly access and
exclusive write access, would select both flags.

I just sent an (unfortunately) longish but way more detailed email
about live snapshotting with userfaultfd but I just wanted to give a
shorter answer here too :).

Thanks,
Andrea
