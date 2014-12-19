Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaLSBUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:20:02 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:57277 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLSBUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:20:00 -0500
Message-ID: <1418951998.4830.7.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] uapi/linux/target_core_user.h: fix headers_install.sh
 badness
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Kyle McMartin <kyle@redhat.com>
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, jbastian@redhat.com,
        target-devel <target-devel@vger.kernel.org>
Date: Thu, 18 Dec 2014 17:19:58 -0800
In-Reply-To: <20141218175714.GF5157@redacted.bos.redhat.com>
References: <20141218175714.GF5157@redacted.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

On Thu, 2014-12-18 at 12:57 -0500, Kyle McMartin wrote:
> scripts/headers_install.sh will transform __packed to
> __attribute__((packed)), so the #ifndef is not necessary.
> (and, in fact, it's problematic, because we'll end up with the header
>  containing:
> #ifndef __attribute__((packed))
> #define __attribu...
> and so forth.)
> 
> Cc: stable@vger.kernel.org # 3.18
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> ---
> cc-ing stable@ so this headers fix gets picked up by distros.
> 
> --- a/include/uapi/linux/target_core_user.h
> +++ b/include/uapi/linux/target_core_user.h
> @@ -6,10 +6,6 @@
>  #include <linux/types.h>
>  #include <linux/uio.h>
>  
> -#ifndef __packed
> -#define __packed                        __attribute__((packed))
> -#endif
> -
>  #define TCMU_VERSION "1.0"
>  
>  /*

Applied to target-pending/for-next.

Thanks!

--nab


