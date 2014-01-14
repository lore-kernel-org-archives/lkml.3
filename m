Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaANQDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:03:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:31591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaANQD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:03:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="458622656"
Message-ID: <52D55F92.8040108@linux.intel.com>
Date: Tue, 14 Jan 2014 08:02:26 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86, kaslr] BUG: kernel boot hang
References: <20140114133125.GB26942@localhost>
In-Reply-To: <20140114133125.GB26942@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:31 AM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Thu Oct 10 17:18:16 2013 -0700
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun Oct 13 03:12:19 2013 -0700
> 
>     x86, kaslr: Select random position from e820 maps
>     
>     Counts available alignment positions across all e820 maps, and chooses
>     one randomly for the new kernel base address, making sure not to collide
>     with unsafe memory areas.
>     
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> Note that there are many other warning/errors and it's not very
> reproducible, so this report might be wrong.
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> 

I wonder if this is in any way related to the fact that the ELF parser
we have in the decompressor is quite frankly complete crap... it assumes
that all sections can only be moved downward.

	-hpa


