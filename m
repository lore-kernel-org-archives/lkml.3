Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3LCCe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:34:58 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37605 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3LCCew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311261659010.11450@tamien>
References: <alpine.DEB.2.02.1311261659010.11450@tamien>
Date: Tue, 3 Dec 2013 10:34:52 +0800
Message-ID: <CAMk6uBn=p-9VNfWx=Ce+M6_ZgXQ+JdQj_L3Q_vMg4gh1WunMxA@mail.gmail.com>
Subject: Re: [PATCH] blackfin: bf60x: clock: return 0 upon error from clk_round_rate()
From: Steven Miao <realmz6@gmail.com>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Applied to next 3.14 tree. Thanks!

On Wed, Nov 27, 2013 at 9:00 AM, Paul Walmsley <pwalmsley@nvidia.com> wrote:
>
> clk_round_rate() should return 0 upon an error, rather than returning
> a negative error code.  This is because clk_round_rate() is being
> changed to return an unsigned return type rather than a signed type,
> since some clock sources can generate rates higher than (2^31)-1 Hz.
>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Steven Miao <realmz6@gmail.com>
> Cc: Bob Liu <lliubbo@gmail.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> ---
> Applies on v3.13-rc1.  See also:
>
> http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2
>
>  arch/blackfin/mach-bf609/clock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/blackfin/mach-bf609/clock.c
> b/arch/blackfin/mach-bf609/clock.c
> index dab8849af884..3f5323d3e116 100644
> --- a/arch/blackfin/mach-bf609/clock.c
> +++ b/arch/blackfin/mach-bf609/clock.c
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL(clk_get_rate);
>
>  long clk_round_rate(struct clk *clk, unsigned long rate)
>  {
> -       long ret = -EIO;
> +       long ret = 0;
>         if (clk->ops && clk->ops->round_rate)
>                 ret = clk->ops->round_rate(clk, rate);
>         return ret;
