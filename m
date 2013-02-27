Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3B0B1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:27:52 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57655 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab3B0B1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:27:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130223074001.GA5199@www.outflux.net>
References: <20130223074001.GA5199@www.outflux.net>
Date: Tue, 26 Feb 2013 17:27:45 -0800
X-Google-Sender-Auth: RIAL8vJSyAOGgcPeIhTzKBuH8MM
Message-ID: <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
From: Dan Williams <djbw@fb.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 7cdf359..0cc3a3d 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>         depends on MD_RAID456
>         depends on SMP
> -       depends on EXPERIMENTAL

In this case MULTICORE_RAID456 and the related code should go as
well... now that there are patches to supersede this implementation in
md-next.

--
Dan
