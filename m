Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbaGWQif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:38:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:56774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397AbaGWQid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="547849209"
Message-ID: <53CFE4F9.3000701@intel.com>
Date: Wed, 23 Jul 2014 09:38:17 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com> <1405921124-4230-10-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1405921124-4230-10-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 10:38 PM, Qiaowei Ren wrote:
> Since the kernel allocated those tables on-demand without userspace
> knowledge, it is also responsible for freeing them when the associated
> mappings go away.
> 
> Here, the solution for this issue is to hook do_munmap() to check
> whether one process is MPX enabled. If yes, those bounds tables covered
> in the virtual address region which is being unmapped will be freed also.

This is the part of the code that I'm the most concerned about.

Could you elaborate on how you've tested this to make sure it works OK?
