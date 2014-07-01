Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaGAOWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595AbaGAOWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:22:44 -0400
Date: Tue, 1 Jul 2014 10:22:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "HATAYAMA, Daisuke" <d.hatayama@jp.fujitsu.com>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, acme@kernel.org,
        mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
Message-ID: <20140701142201.GU7959@redhat.com>
References: <20140613084437.12424.62294.stgit@localhost6.localdomain6>
 <20140616153047.GJ177152@redhat.com>
 <53B12CB3.5050508@jp.fujitsu.com>
 <20140630222224.GH19781@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630222224.GH19781@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:22:24PM -0700, Andi Kleen wrote:
> > 
> > I'm also interested in the behaviour of CondChgd bit on Ivy Bridge processors.
> 
> The intended meaning of CondChgd is that a hardware debugger has taken over the
> PMU. It shouldn't really be set in other circumstances.

Interesting.  My concern is we have customers that can soft reboot a
machine and have this bit accidentally be enabled.  I am pretty sure they
do not have a hardware debugger attached (I would have to double check).
Is there other ways this can be set?

Cheers,
Don

> 
> I think right now for perf it would be best to just ignore it.
> 
> In theory could stop using the PMU, but if some BIOS set it it would
> completely disable perf there. So better to just ignore it.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
