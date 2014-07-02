Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaGBPeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:34:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:62963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaGBPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:34:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="567323918"
Date: Wed, 2 Jul 2014 08:33:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702153300.GM19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <CABPqkBT1XC=mG-ZhjAcMOksdCgP-p3TSSAefi7XBOajMugBYZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT1XC=mG-ZhjAcMOksdCgP-p3TSSAefi7XBOajMugBYZQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, still needs to be INTEL_ALL_EVENT_CONSTRAINT(0x0, 0x1)
> otherwise the get_event_constraint() test I mentioned previously will
> fail, event with your ALL_FILTER mask.

What events should fail? I verified all PEBS events and they work as expected.

> > -       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> > -       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
> > -       INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> > -       INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> > -       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> > -       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> > -       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> > -       INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> > -       INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
> > +       INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
> > +       INTEL_PST_CONSTRAINT(0x02cd, 0xf),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
> 
> No, precise stores only work on counter 3, keep 0x8 here

Good point.



-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
