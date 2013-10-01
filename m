Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3JAMpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:45:45 -0400
Received: from imap.thunk.org ([74.207.234.97]:40714 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab3JAMpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:45:43 -0400
Date: Tue, 1 Oct 2013 08:45:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 08/11] ext4: Fix end of group handling in
 ext4_mb_init_cache
Message-ID: <20131001124541.GB2097@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>, linux-ext4@vger.kernel.org
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380572952-30729-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:29:09PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The first loop in ext4_mb_init_cache can bail out when the end of
> all groups is reached. Unfortunately the later loops did not
> have that check and could access uninitialized buffer pointers
> in bh[]. Add the end of group check everywhere.
> 
> Cc: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Makefile          | 6 +++---
>  fs/ext4/mballoc.c | 6 +++++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8d0668f..be3ef83 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -663,9 +663,9 @@ KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
>  KBUILD_ARFLAGS := $(call ar-option,D)
>  
>  # check for 'asm goto'
> -ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
> -	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
> -endif
> +#ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
> +#	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
> +#endif
>  
>  # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
>  KBUILD_CPPFLAGS += $(KCPPFLAGS)

What's this change all about, and why is it included in this
patch?

						- Ted
