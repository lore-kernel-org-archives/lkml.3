Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3JKJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:05:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:11416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3JKJFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="409321474"
Date: Fri, 11 Oct 2013 17:05:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        hannes@cmpxchg.org, darrick.wong@oracle.com,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Message-ID: <20131011090534.GA29330@localhost>
References: <5251CF94.5040101@gmx.de>
 <CAMuHMdWs6Y7y12STJ+YXKJjxRF0k5yU9C9+0fiPPmq-GgeW-6Q@mail.gmail.com>
 <525591AD.4060401@gmx.de>
 <5255A3E6.6020100@nod.at>
 <20131009214733.GB25608@quack.suse.cz>
 <5255D9A6.3010208@nod.at>
 <5256DA9A.5060904@gmx.de>
 <20131011011649.GA11191@localhost>
 <5257B9EB.7080503@gmx.de>
 <20131011085701.GA27382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131011085701.GA27382@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 04:57:01PM +0800, Fengguang Wu wrote:
> On Fri, Oct 11, 2013 at 10:42:19AM +0200, Toralf Förster wrote:
> > yeah, now the picture becomes more clear
> > ...
> > net.core.warnings = 0                                                                         [ ok ]
> > ick: pause : -717
> >                  ick : min_pause : -177
> >                                    ick : max_pause : -717
> >                                                      ick: pages_dirtied : 14
> >                                                                             ick: task_ratelimit: 0
> 
> Great and thanks! So it's the max pause calculation went wrong.

However I still suspect this is not the main reason for the soft
lockup. Because schedule_timeout() will directly return on negative
timeout. So yes, we have encountered some negative pauses, however
we still need to fix the huge dirtied pages problem which should be
more fundamental. 

Thanks,
Fengguang
