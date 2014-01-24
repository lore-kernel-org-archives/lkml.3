Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaAXPZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:25:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:53865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbaAXPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471908752"
Message-ID: <52E285DA.1090107@intel.com>
Date: Fri, 24 Jan 2014 07:25:14 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
References: <52E19C7D.7050603@intel.com> <CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com> <52E28067.1060507@intel.com>
In-Reply-To: <52E28067.1060507@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 07:01 AM, Dave Hansen wrote:
> There are two failure modes I'm seeing: one when (failing to) allocate
> the first node's mem_map[], and a second where it oopses accessing the
> numa_distance[] table.  This is the numa_distance[] one, and it happens
> even with the patch you suggested applied.

And with my second (lots of debugging enabled) config, I get the
mem_map[] oops.  In other words, none of the reverts or patches are
helping either of the conditions that I'm able to trigger.

