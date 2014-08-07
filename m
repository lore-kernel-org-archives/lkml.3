Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaHGQD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:03:59 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:39725 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:03:57 -0400
Date: Thu, 7 Aug 2014 18:03:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140807160352.GB1382@ravnborg.org>
References: <20140806222419.GA2566@jtriplet-mobl1>
 <20140806223152.GA14348@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806223152.GA14348@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:31:54PM -0700, Josh Triplett wrote:
> Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
> allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
> "make allnoconfig" disables every possible config option.
> 
> However, a few configuration options (CC_OPTIMIZE_FOR_SIZE,
> OPTIMIZE_INLINING) produce a smaller kernel when turned on, and a few
> choices exist (compression, highmem, allocator) for which a non-default
> option produces a smaller kernel.
> 
> Add a "tinyconfig" option, which starts from allnoconfig and then sets
> these options to configure the tiniest possible kernel.  This provides a
> better baseline for embedded systems or efforts to reduce kernel size.

In general I dislike the whole approach where we introduce makefile
magic to support diverse config snippets.
Another approch where we factor out this from the MAkefile seems much leaner.

And for this specific patch then this is not x86 specific at all.
If we keep the logic in the makefiles than we should:
1) Make the infrastructure general
2) Document it
3) Find another home for the config snippets that are non-arch specific like this one

	Sam

> diff --git a/arch/x86/configs/tiny.config b/arch/x86/configs/tiny.config
> new file mode 100644
> index 0000000..8f0e54c
> --- /dev/null
> +++ b/arch/x86/configs/tiny.config
> @@ -0,0 +1,5 @@
> +CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> +CONFIG_KERNEL_XZ=y
> +CONFIG_NOHIGHMEM=y
> +CONFIG_OPTIMIZE_INLINING=y
> +CONFIG_SLOB=y
All the above are general options that apply equal to arm than to x86.

	Sam
