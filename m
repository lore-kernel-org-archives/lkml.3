Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3ETJKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:10:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44154 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab3ETJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:10:54 -0400
Date: Mon, 20 May 2013 10:10:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
Message-ID: <20130520091008.GB31359@mudshark.cambridge.arm.com>
References: <5199B7D6.40907@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5199B7D6.40907@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Mon, May 20, 2013 at 06:42:46AM +0100, Chen Gang wrote:
> 
> Add the extern variable 'screen_info' according to arm32 has done.
> 
> The related error:
>   drivers/video/console/vgacon.c:1305: undefined reference to `screen_info'
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/kernel/setup.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index add6ea6..1055992 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -374,3 +374,14 @@ const struct seq_operations cpuinfo_op = {
>  	.stop	= c_stop,
>  	.show	= c_show
>  };
> +
> +#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
> +struct screen_info screen_info = {
> +	.orig_video_lines	= 30,
> +	.orig_video_cols	= 80,
> +	.orig_video_mode	= 0,
> +	.orig_video_ega_bx	= 0,
> +	.orig_video_isVGA	= 1,
> +	.orig_video_points	= 8
> +};
> +#endif

I think it would be better if we added a something like
CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
like x86 can then select the former, and we can remove the long list of
architectures from the current option.

Will
