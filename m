Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3HPQgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:36:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:51671 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab3HPQgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,895,1367996400"; 
   d="scan'208";a="388287263"
Message-ID: <520E5517.9070606@intel.com>
Date: Fri, 16 Aug 2013 09:36:39 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, holt@sgi.com, rob@landley.net, travis@sgi.com,
        daniel@numascale-asia.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, yinghai@kernel.org, mgorman@suse.de
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com> <1376344480-156708-1-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1376344480-156708-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Nathan,

Could you post your boot timing patches?  My machines are much smaller
than yours, but I'm curious how things behave here as well.

I did some very imprecise timings (strace -t on a telnet attached to the
serial console).  The 'struct page' initializations take about a minute
of boot time for me to do 1TB across 8 NUMA nodes (this is a glueless
QPI system[1]).  My _quick_ calculations look like it's 2x as fast to
initialize node0's memory vs. the other nodes, and boot time is
increased by a second for about every 30G of memory we add.

So even with nothing else fancy, we could get some serious improvements
from just doing the initialization locally.

[1] We call anything using pure QPI without any other circuitry for the
NUMA interconnects to be "glueless"

	
