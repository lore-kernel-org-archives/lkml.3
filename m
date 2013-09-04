Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336Ab3IDKZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:25:22 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:34175 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3IDKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:25:20 -0400
Message-ID: <52270A5B.2040600@free.fr>
Date: Wed, 04 Sep 2013 12:24:27 +0200
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Expose buffer size to userspace (v2)
References: <1378264549-9185-1-git-send-email-christopher.halse.rogers@canonical.com>
In-Reply-To: <1378264549-9185-1-git-send-email-christopher.halse.rogers@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,
Le 04/09/2013 05:15, Christopher James Halse Rogers a écrit :
> Each dma-buf has an associated size and it's reasonable for userspace
> to want to know what it is.
>
> Since userspace already has an fd, expose the size using the
> size = lseek(fd, SEEK_END, 0); lseek(fd, SEEK_CUR, 0);
> idiom.
>
> v2: Added Daniel's sugeested documentation, with minor fixups
>
> Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>   Documentation/dma-buf-sharing.txt | 12 ++++++++++++
>   drivers/base/dma-buf.c            | 28 ++++++++++++++++++++++++++++
>   2 files changed, 40 insertions(+)
>
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 0b23261..849e982 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -407,6 +407,18 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
>      interesting ways depending upong the exporter (if userspace starts depending
>      upon this implicit synchronization).
>   
> +Other Interfaces Exposed to Userspace on the dma-buf FD
> +------------------------------------------------------
> +
> +- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
> +  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
> +  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
> +  llseek operation will report -EINVAL.
> +
> +  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
Shouldn't it be "supported" instead of "support"?

Anyway, I'm just curious, in which case is it important to know the size?
Do we already have a way to get the dimensions (x, y and stripe)?
