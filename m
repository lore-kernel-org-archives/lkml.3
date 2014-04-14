Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaDNS7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:59:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaDNS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:58:57 -0400
Message-ID: <534C2FEB.2000803@canonical.com>
Date: Mon, 14 Apr 2014 14:58:51 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org
CC: linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH 1/1] powerpc: Increase COMMAND_LINE_SIZE to 2048 from
 512.
References: <cover.1397260361.git.joseph.salisbury@canonical.com> <84356b1cb9452226d54641a71e4b1363e78d4417.1397260362.git.joseph.salisbury@canonical.com>
In-Reply-To: <84356b1cb9452226d54641a71e4b1363e78d4417.1397260362.git.joseph.salisbury@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 11:30 AM, Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1306677
>
> While booting the PPC64EL kernel, the command line gets truncated to 512 characters. This is due to a hard limit of 512 defined for COMMAND_LINE_SIZE.  It would be beneficial to have a command line longer than 512 characters, as iscsi targets and cloud-init parameters are passed through the kernel command line.
>
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org> (supporter:LINUX FOR POWERPC...)
> Cc: Paul Mackerras <paulus@samba.org> (supporter:LINUX FOR POWERPC...)
> Cc: linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
> Cc: linux-kernel@vger.kernel.org (open list)
> Cc: stable@vger.kernel.org
>
> ---
>  arch/powerpc/boot/ops.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
> index b3218ce..5a01fb1 100644
> --- a/arch/powerpc/boot/ops.h
> +++ b/arch/powerpc/boot/ops.h
> @@ -15,7 +15,7 @@
>  #include "types.h"
>  #include "string.h"
>  
> -#define	COMMAND_LINE_SIZE	512
> +#define	COMMAND_LINE_SIZE	2048	
>  #define	MAX_PATH_LEN		256
>  #define	MAX_PROP_LEN		256 /* What should this be? */
>  

After further review, it appears ppc does not actually use the define in
the ppc headers but uses the common generic
default(include/uapi/asm-generic/setup.h).  COMMAND_LINE_SIZE should
probably become a kernel config option.  Do folks agree that is the
correct thing to do?  If so, I can re-work the patch.

Thanks,

Joe
