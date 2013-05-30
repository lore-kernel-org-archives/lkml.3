Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3E3TSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:18:18 -0400
Received: from www.sr71.net ([198.145.64.142]:59461 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab3E3TSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:18:14 -0400
Message-ID: <51A7A5F3.4040704@sr71.net>
Date: Thu, 30 May 2013 12:18:11 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] sparsemem: BUILD_BUG_ON when sizeof mem_section is non-power-of-2
References: <51A78EC4.4080703@intel.com> <1369939248-10006-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1369939248-10006-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 11:40 AM, Cody P Schafer wrote:
> Instead of leaving a hidden trap for the next person who comes along and
> wants to add something to mem_section, add a big fat warning about it
> needing to be a power-of-2, and insert a BUILD_BUG_ON() in sparse_init()
> to catch mistakes.
> 
> Right now non-power-of-2 mem_sections cause a number of WARNs at boot
> (which don't clearly point to the size of mem_section as an issue), but
> the system limps on (temporarily, at least).
> 
> This is based upon Dave Hansen's earlier RFC where he ran into the same
> issue:
> 	"sparsemem: fix boot when SECTIONS_PER_ROOT is not power-of-2"
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/03077.html

Thanks for doing that, Cody.  At the risk of patting myself on the back:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
