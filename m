Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab3CGEbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:31:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50092 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3CGEbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:31:13 -0500
Message-ID: <5138180B.3010503@zytor.com>
Date: Wed, 06 Mar 2013 20:31:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Be explicit about what the x86 0x020c boot parameter
 version requires.
References: <51377C3A.3030301@zytor.com> <1362592823-28967-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1362592823-28967-1-git-send-email-pjones@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 10:00 AM, Peter Jones wrote:
> This should help avoid making the incorrect change in non-compliant
> bootloaders.
> 
> Signed-off-by: Peter Jones <pjones@redhat.com>
> ---
>  Documentation/x86/boot.txt             | 5 +++--
>  arch/x86/include/asm/bootparam_utils.h | 7 +++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 3840b6f..72702db 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -1110,7 +1110,8 @@ firmware, 'table' is the EFI system table - these are the first two
>  arguments of the "handoff state" as described in section 2.3 of the
>  UEFI specification. 'bp' is the boot loader-allocated boot params.
>  
> -The boot loader *must* fill out the following fields in bp,
> +The boot loader *must* zero the entirity of bp, and then fill out the
> +following fields:
>  
>      o hdr.code32_start
>      o hdr.cmd_line_ptr
> @@ -1118,4 +1119,4 @@ The boot loader *must* fill out the following fields in bp,
>      o hdr.ramdisk_image (if applicable)
>      o hdr.ramdisk_size  (if applicable)
>  

Wait a bloody minute here... I seem to have managed to miss something big.

Matt, should we not be copying the setup part of the structure just as
we do for the normal 32/64-bit protocol?  If not, why not?


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

