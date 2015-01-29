Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbbA2MGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:06:53 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51671 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbA2MGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:06:52 -0500
Message-ID: <54CA2256.9000209@hurleysoftware.com>
Date: Thu, 29 Jan 2015 07:06:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] vt_buffer: drop console buffer copying optimisations
References: <1422504685-7864-1-git-send-email-airlied@redhat.com>
In-Reply-To: <1422504685-7864-1-git-send-email-airlied@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 11:11 PM, Dave Airlie wrote:
> These two copy to/from VGA memory, however on the Silicon
> Motion SMI750 VGA card on a 64-bit system cause console corruption.
> 
> This is due to the hw being buggy and not handling a 64-bit transaction
> correctly.
> 
> We could try and create a 32-bit version of these routines,
> but I'm not sure the optimisation is worth much today.
> 
> Fixes https://bugzilla.redhat.com/show_bug.cgi?id=1132826

Restricted link.


> Tested-by: Huawei engineering.
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
> 
> Linus, this came up a while back I finally got some confirmation
> that it fixes those servers.
> 
>  include/linux/vt_buffer.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/linux/vt_buffer.h b/include/linux/vt_buffer.h
> index 057db7d..f38c10b 100644
> --- a/include/linux/vt_buffer.h
> +++ b/include/linux/vt_buffer.h
> @@ -21,10 +21,6 @@
>  #ifndef VT_BUF_HAVE_RW
>  #define scr_writew(val, addr) (*(addr) = (val))
>  #define scr_readw(addr) (*(addr))
> -#define scr_memcpyw(d, s, c) memcpy(d, s, c)
> -#define scr_memmovew(d, s, c) memmove(d, s, c)
> -#define VT_BUF_HAVE_MEMCPYW
> -#define VT_BUF_HAVE_MEMMOVEW
>  #endif
>  
>  #ifndef VT_BUF_HAVE_MEMSETW
> 

