Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965747Ab3E3Rj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:39:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:8115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668Ab3E3RjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="345833698"
Message-ID: <51A78EC4.4080703@intel.com>
Date: Thu, 30 May 2013 10:39:16 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: sparse: use __aligned() instead of manual padding
 in mem_section
References: <1369869279-20155-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1369869279-20155-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 04:14 PM, Cody P Schafer wrote:
> Instead of leaving a trap for the next person who comes along and wants
> to add something to mem_section, add an __aligned() and remove the
> manual padding added for MEMCG.

It doesn't need to be aligned technically.  It needs to be a power-of-2:

http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/03077.html

I'd be quite happy for someone to resurrect that patch, though.  We need
a big fat comment in there.
