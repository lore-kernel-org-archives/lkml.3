Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaIDUOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:14:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaIDUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:14:09 -0400
Date: Thu, 4 Sep 2014 13:14:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: [PATCH] kern/sys: Compat sysinfo syscall fix undefined behavior
Message-Id: <20140904131408.5b50c44315263c497ac7d818@linux-foundation.org>
In-Reply-To: <5408B39D.4030400@eng.utah.edu>
References: <5408B39D.4030400@eng.utah.edu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014 12:46:53 -0600 Scotty Bauer <sbauer@eng.utah.edu> wrote:

> Fix undefined behavior and compiler warning by replacing right
> shift 32 with upper_32_bits macro
> 
> Signed-off-by: Scotty Bauer <sbauer@eng.utah.edu>
> ---
>  kernel/sys.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index ce81291..c78530b 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2135,7 +2135,7 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
>  	/* Check to see if any memory value is too large for 32-bit and scale
>  	 *  down if needed
>  	 */
> -	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
> +	if (upper_32_bits(s.totalram) || upper_32_bits(s.totalswap)) {
>  		int bitcount = 0;
>  
>  		while (s.mem_unit < PAGE_SIZE) {

Fair enough.

If I'm reading it correctly, this is all dead code because si_meminfo()
unconditionally sets sysinfo.mem_unit to PAGE_SIZE.

It could all do with a bit of a cleanup, I suspect.
