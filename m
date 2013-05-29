Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153Ab3E2Hrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:47:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33975 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935106Ab3E2Hrg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 29 May 2013 03:47:36 -0400
Message-Id: <51A5CEB402000078000D97BA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 08:47:32 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "John Stultz" <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when
 the system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
 <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.05.13 at 20:22, David Vrabel <david.vrabel@citrix.com> wrote:
> @@ -199,28 +201,59 @@ static void xen_get_wallclock(struct timespec *now)
>  
>  static int xen_set_wallclock(const struct timespec *now)
>  {
> -	struct xen_platform_op op;
> -	int ret;
> -
>  	/* do nothing for domU */
>  	if (!xen_initial_domain())
>  		return -1;
>  
> -	/* Set the Xen wallclock. */
> +	/* Set the hardware RTC. */
> +	return mach_set_rtc_mmss(now);
> +
> +}

Can't you achieve the same effect in a cleaner way by overriding
x86_platform.set_wallclock only in the non-init-domain case?

Jan

