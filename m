Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936083Ab3BOQZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:25:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37221 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936065Ab3BOQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:25:41 -0500
Message-ID: <511E617E.6080206@wwwdotorg.org>
Date: Fri, 15 Feb 2013 09:25:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC 1/2] Makefile: Add arch/arch/$(hdr-arch)/boot in header
 include path
References: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 01:52 AM, Hiroshi Doyu wrote:
> With a new feature dtc+cpp, DT can introduces some definitions in its
> header files for their own. Some of those DT info can be used in
> kernel source as well, instead of having the duplicate info in kernel
> headers. This patch allows kernel source to include those DT
> headers. For example:
> 
> + #include <dts/tegra20-car.h>

Since this is devicetree-related, the DT maintainers should also be
CC'd. I've added them on this email, hence quoting the entire patch.

> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 0b4bf62..7f54cdb 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -364,7 +364,7 @@ LINUXINCLUDE    := \
>  		-I$(srctree)/arch/$(hdr-arch)/include \
>  		-Iarch/$(hdr-arch)/include/generated \
>  		$(if $(KBUILD_SRC), -I$(srctree)/include) \
> -		-Iinclude \
> +		-Iinclude -Iarch/$(hdr-arch)/boot \
>  		$(USERINCLUDE)
>  
>  KBUILD_CPPFLAGS := -D__KERNEL__
> 

