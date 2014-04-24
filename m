Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaDXPGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:06:36 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:40985 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaDXPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:06:32 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 24 Apr 2014 08:06:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        eparis@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org,
        kyungsik.lee@lge.com, jslaby@suse.cz, dwight.engen@oracle.com,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE
 documentation
Message-ID: <20140424150621.GB2969@jtriplet-mobl1>
References: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
 <1398341254-4626-2-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398341254-4626-2-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:07:34PM +0200, Michael Opdenacker wrote:
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

The benchmarks from your cover letter should appear here in the commit
message, along with corresponding information about kernel size.

> ---
>  init/Kconfig | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3585bb2a7a..b6394a9ddc38 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1251,7 +1251,19 @@ config CC_OPTIMIZE_FOR_SIZE
>  	bool "Optimize for size"
>  	help
>  	  Enabling this option will pass "-Os" instead of "-O2" to gcc
> -	  resulting in a smaller kernel.
> +	  resulting in a smaller but slower kernel.
> +
> +	  This option can be useful in very small systems where every
> +	  byte counts.
> +
> +	  A smaller kernel will also be slightly faster to load and start.
> +	  However, experiments have shown that such early speedups are
> +	  quickly offset by the slower kernel speed. Unless you are running
> +	  a very simple user space, the total boot time should be degraded
> +	  by this option.
> +
> +	  Anyway, kernel code will be slower to execute and overall system
> +  	  performance will be degraded.

I'd suggest leaving out the middle paragraph ("A smaller kernel
will...") entirely; it seems already implied by "smaller but slower
kernel", and the last sentence of that paragraph seems quite speculative
given your benchmarks in the cover letter.  That already should
counteract any mistaken impression people might have that -Os would
speed the kernel up.  How about:

	  This option can be useful on very small systems where every
	  byte counts.  However, the resulting kernel will be slower to
	  execute, and overall system performance will be degraded.

Also, when you collected your performance benchmarks, did you collect
any profiling information on what part of the kernel got slower?
Compiling a couple of kernel hotspots with -O2 (or -O3) might eliminate
the performance delta.

- Josh Triplett
