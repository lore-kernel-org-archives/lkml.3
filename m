Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbbABJqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:46:48 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53938 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbABJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:46:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-omap2: voltage.c: Remove some unused functions
Date: Fri, 02 Jan 2015 10:46:35 +0100
Message-ID: <3966855.LUXW4xbVYM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420131994-31636-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131994-31636-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:xvsvUokDlxZ4TImGRK0oNMoIfhb3QOSg9zqdT/Rv7nrHxXtC4CL
 oiuNTAyM7sVjfHZ0V6l88Wm//KqedycpyAULcXZ5+qX0MN54gcPUoMfq/lGj6COS/TiRqrc
 y097B9sZRgOCGB9HERf6dirVUeLux4IOrigbfWjFIXgdp1/I3IBp5WRWP63FNnh+KJdKoVM
 LI+HWI4P5RG3t75VlDiEw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2015 18:06:34 Rickard Strandqvist wrote:

> -void omap_change_voltscale_method(struct voltagedomain *voltdm,
> -				  int voltscale_method)
> -{
> -	if (!voltdm || IS_ERR(voltdm)) {
> -		pr_warn("%s: VDD specified does not exist!\n", __func__);
> -		return;
> -	}
> -
> -	switch (voltscale_method) {
> -	case VOLTSCALE_VPFORCEUPDATE:
> -		voltdm->scale = omap_vp_forceupdate_scale;
> -		return;
> -	case VOLTSCALE_VCBYPASS:
> -		voltdm->scale = omap_vc_bypass_scale;
> -		return;
> -	default:
> -		pr_warn("%s: Trying to change the method of voltage scaling to an unsupported one!\n",
> -			__func__);
> -	}
> -}

The VOLTSCALE_VPFORCEUPDATE/VOLTSCALE_VCBYPASS macros are now unused and should
be removed as well.

> @@ -321,10 +290,9 @@ static struct voltagedomain *_voltdm_lookup(const char *name)
>   * @voltdm: struct voltagedomain * to add the powerdomain to
>   * @pwrdm: struct powerdomain * to associate with a voltagedomain
>   *
> - * Associate the powerdomain @pwrdm with a voltagedomain @voltdm.  This
> - * enables the use of voltdm_for_each_pwrdm().  Returns -EINVAL if
> - * presented with invalid pointers; -ENOMEM if memory could not be allocated;
> - * or 0 upon success.
> + * Associate the powerdomain @pwrdm with a voltagedomain @voltdm.
> + * Returns -EINVAL if presented with invalid pointers;
> + * -ENOMEM if memory could not be allocated; or 0 upon success.
>   */
>  int voltdm_add_pwrdm(struct voltagedomain *voltdm, struct powerdomain *pwrdm)
>  {

You have correctly spotted the only place that references voltdm_for_each_pwrdm
and changed the comment, but you failed to notice that it no longer makes
sense to call voltdm_add_pwrdm or keep the voltdm->pwrdm_list pointer
at all, so this function, and the associated list heads can all be removed
as well.

	Arnd
