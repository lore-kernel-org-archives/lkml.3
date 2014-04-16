Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaDPCFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:05:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:57986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaDPCFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,868,1389772800"; 
   d="scan'208";a="521367494"
Message-ID: <534DE562.8040700@linux.intel.com>
Date: Tue, 15 Apr 2014 19:05:22 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [x86, smap]  general protection fault: fff2 [#1] PREEMPT DEBUG_PAGEALLOC
References: <53477D33.8030809@intel.com>
In-Reply-To: <53477D33.8030809@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 10:27 PM, Jet Chen wrote:
> [  371.380921] general protection fault: fff2 [#1] PREEMPT DEBUG_PAGEALLOC

I am guessing this is an issue with DEBUG_PAGEALLOC... this message is
odd in the extreme because it is hard to see how we could #GP(0xfff2)
here -- which normally would indicate having attempted to load 0xfff2 as
a segment selector (which is going to fail spectacularly).

This happens immediately after a popfq which enables interrupts(!), so
my guess is that we're trying to deliver an interrupt but that for some
reason there is garbage in the IDT or similar.

Unfortunately the GPF message doesn't include the IDT/GDT information...

	-hpa

