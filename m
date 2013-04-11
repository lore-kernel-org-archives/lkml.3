Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3DKHi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:38:27 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:38967 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3DKHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:38:25 -0400
Message-ID: <51666860.5060407@synopsys.com>
Date: Thu, 11 Apr 2013 13:08:08 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH] Add option to disable kernel compression
References: <1365508161-32154-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1365508161-32154-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 05:19 PM, Christian Ruppert wrote:
> Until now, kernel compression can only be disabled by deselecting
> HAVE_<compression> in the architecture Kconfig. However, some
> users/platforms within the same architecture might want to use
> compression while others might want to disable it.
> This patch is a solution to the dilemma.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  init/Kconfig |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 5341d72..0924c51 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -101,7 +101,6 @@ config HAVE_KERNEL_LZO
>  choice
>  	prompt "Kernel compression mode"
>  	default KERNEL_GZIP
> -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO
>  	help
>  	  The linux kernel is a kind of self-extracting executable.
>  	  Several compression algorithms are available, which differ
> @@ -120,6 +119,13 @@ choice
>  
>  	  If in doubt, select 'gzip'
>  
> +config KERNEL_UNCOMPRESSED
> +	bool "No compression"

> +	help
> +	  No compression at all. The kernel is huge but the compression and
> +	  decompression times are zero.
> +	  This is usually not what you want.
> +
>  config KERNEL_GZIP
>  	bool "Gzip"
>  	depends on HAVE_KERNEL_GZIP

FWIW, this is an issue for ARC port where one of our platforms runs on a very slow
FPGA, hence doesn't want to spend time uncompressing the image - while others do
want the gzip.

Reviewed-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
