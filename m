Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaF3WWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:22:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:3186 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaF3WWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:22:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,577,1400050800"; 
   d="scan'208";a="451797094"
Date: Mon, 30 Jun 2014 15:22:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "HATAYAMA, Daisuke" <d.hatayama@jp.fujitsu.com>
Cc: hpa@zytor.com, Don Zickus <dzickus@redhat.com>, matt@console-pimps.org,
        peterz@infradead.org, acme@kernel.org, mingo@redhat.com,
        paulus@samba.org, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
Message-ID: <20140630222224.GH19781@tassilo.jf.intel.com>
References: <20140613084437.12424.62294.stgit@localhost6.localdomain6>
 <20140616153047.GJ177152@redhat.com>
 <53B12CB3.5050508@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B12CB3.5050508@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'm also interested in the behaviour of CondChgd bit on Ivy Bridge processors.

The intended meaning of CondChgd is that a hardware debugger has taken over the
PMU. It shouldn't really be set in other circumstances.

I think right now for perf it would be best to just ignore it.

In theory could stop using the PMU, but if some BIOS set it it would
completely disable perf there. So better to just ignore it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
