Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaAPIpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:45:07 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44618 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaAPIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:45:03 -0500
Date: Thu, 16 Jan 2014 09:44:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: fix 27-rc crash on vsmp due to paravirt
 during module load"
Message-ID: <20140116084458.GA9346@gmail.com>
References: <1389838259-29411-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389838259-29411-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> This reverts commit 05e12e1c4c09cd35ac9f4e6af1e42b0036375d72.
> 
> The old change from __init --> __init_or_module doesn't make
> sense anymore, given that the arch/x86/kernel/vsmp_64.c code
> is only for non-modular builds.
> 
> As of commit 70511134f61bd6e5eed19f767381f9fb3e762d49
> ("Revert "x86: don't compile vsmp_64 for 32bit") this file
> became obj-y and hence is only for built-in.  That makes
> any "or_module" support redundant.
> 
> We need to distinguish between the two in order to do some
> header cleanups.  This revert starts that process.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I suspect you want to carry this as part of your header cleanups, to 
not have to wait for upstream propagation?

Please fix the title: the original commit was right, but was mooted by 
other changes. That's not a revert but a change that happens to be the 
inverse of an earlier change.

Thanks,

	Ingo
