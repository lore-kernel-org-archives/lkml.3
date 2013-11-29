Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3K2CGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:06:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:9977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3K2CG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:06:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,795,1378882800"; 
   d="scan'208";a="435851101"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>
CC: William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, azurIt <azurit@pobox.sk>,
        Sameer Nanda <snanda@chromium.org>
Subject: RE: [PATCH] Fix race between oom kill and task exit
Thread-Topic: [PATCH] Fix race between oom kill and task exit
Thread-Index: AQHO7GkIAtgpkv7roka7vtUbU5xUepo7dWXA
Date: Fri, 29 Nov 2013 02:06:25 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD025310D2@SHSMSX103.ccr.corp.intel.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
 <20131128063505.GN3556@cmpxchg.org>
 <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com>
 <20131128120018.GL2761@dhcp22.suse.cz> <20131128183830.GD20740@redhat.com>
In-Reply-To: <20131128183830.GD20740@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Oleg Nesterov [mailto:oleg@redhat.com]
> Sent: Friday, November 29, 2013 2:39 AM
> To: Michal Hocko
> Cc: William Dauchy; Johannes Weiner; Ma, Xindong;
> akpm@linux-foundation.org; rientjes@google.com; rusty@rustcorp.com.au;
> linux-mm@kvack.org; linux-kernel@vger.kernel.org; Peter Zijlstra;
> gregkh@linuxfoundation.org; Tu, Xiaobing; azurIt; Sameer Nanda
> Subject: Re: [PATCH] Fix race between oom kill and task exit
> 
> On 11/28, Michal Hocko wrote:
> >
> > They are both trying to solve the same issue. Neither of them is
> > optimal unfortunately.
> 
> yes, but this one doesn't look right.
> 
> > Oleg said he would look into this and I have seen some patches but
> > didn't geto check them.
> 
> Only preparations so far.
> 
> Oleg.

I was not aware there's a long story for this issue. I hit this issue a lot of times during stress test and root caused it. After applying my patch, I did extensive test on 5 machines for a long time, it does not reproduced anymore so I submitted the patch.

I will do more research on this issue.
