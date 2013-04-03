Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940Ab3DCHOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:14:18 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:34671 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615Ab3DCHOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:14:15 -0400
Message-ID: <515BD6B8.1020607@synopsys.com>
Date: Wed, 3 Apr 2013 12:44:00 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        "Stephen Warren" <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1364973141-16354-1-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to CC linux-arch

On 04/03/2013 12:42 PM, Vineet Gupta wrote:
> Currently, for every ARC kernel build I see the following:
>
> --------------->8-----------------
>   DTB    arch/arc/boot/dts/angel4.dtb.S
>   AS      arch/arc/boot/dts/angel4.dtb.o
>   LD      arch/arc/boot/dts/built-in.o
> rm arch/arc/boot/dts/angel4.dtb.S        <-- forces rebuild next iter
>   CHK     kernel/config_data.h
> --------------->8-----------------
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-kbuild@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  scripts/Makefile.lib |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 07125e6..17f96f4 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -265,6 +265,8 @@ cmd_dt_S_dtb=						\
>  	echo '.balign STRUCT_ALIGNMENT'; 		\
>  ) > $@
>  
> +.PRECIOUS: $(obj)/%.dtb.S
> +
>  $(obj)/%.dtb.S: $(obj)/%.dtb
>  	$(call cmd,dt_S_dtb)
>  

