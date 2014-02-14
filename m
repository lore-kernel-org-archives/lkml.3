Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaBNOi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:38:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:43378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaBNOiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:38:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,845,1384329600"; 
   d="scan'208";a="455534551"
Date: Fri, 14 Feb 2014 06:38:23 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [tip:x86/asmlinkage] lto: Make asmlinkage __visible
Message-ID: <20140214143823.GR12219@tassilo.jf.intel.com>
References: <1391846481-31491-3-git-send-email-ak@linux.intel.com>
 <tip-128ea04a9885af9629059e631ddf0cab4815b589@git.kernel.org>
 <20140214091024.GA26664@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214091024.GA26664@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess it is trying to tell me that static function pointers cannot be
> __visible:
> 
> static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
> 
> and
> 
> static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);

Yes there are a couple such warnings now. static asmlinkage
does not make much sense. Can run a cocinelle rule over the tree
later, will send patches. 

-Andi
