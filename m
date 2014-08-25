Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaHYPLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaHYPLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:11:39 -0400
Date: Mon, 25 Aug 2014 17:11:23 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
Message-ID: <20140825151123.GA16532@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <53F61EAC.2000004@redhat.com>
 <20140821165002.GG20453@potion.brq.redhat.com>
 <20140822044503.GB4807@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140822044503.GB4807@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-22 12:45+0800, Wanpeng Li:
> Hi Radim,
> On Thu, Aug 21, 2014 at 06:50:03PM +0200, Radim Krčmář wrote:
> >2014-08-21 18:30+0200, Paolo Bonzini:
> >> Il 21/08/2014 18:08, Radim Krčmář ha scritto:
> >> I'm not sure of the usefulness of patch 6, so I'm going to drop it.
> >> I'll keep it in my local junkyard branch in case it's going to be useful
> >> in some scenario I didn't think of.
> >
> >I've been using it to benchmark different values, because it is more
> 
> Is there any benchmark data for this patchset?

Sorry, I already returned the testing machine and it wasn't quality
benchmarking, so I haven't kept the results ...

I used ebizzy and dbench, because ebizzy had large difference between
PLE on/off and dbench minimal (without overcommit), so one was looking
for improvements while the other was checking regressions.
(And they are easy to set up.)

>From what I remember, this patch had roughly 5x better performance with
ebizzy on 60 VCPU guests and no obvious difference for dbench.
(And improvement under overcommit was visible for both.)

There was a significant reduction in %sys, which never raised much above
30%, as oposed to original 90%+.
