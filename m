Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaJANct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:32:49 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:55317 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJANcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:32:48 -0400
Date: Wed, 1 Oct 2014 15:32:39 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH 10/16] mips: support poweroff through poweroff
 handler call chain
Message-ID: <20141001133238.GJ19854@linux-mips.org>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
 <1412100056-15517-11-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412100056-15517-11-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:00:50AM -0700, Guenter Roeck wrote:

> The kernel core now supports a poweroff handler call chain
> to remove power from the system. Call it if pm_power_off
> is set to NULL.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/mips/kernel/reset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/mips/kernel/reset.c b/arch/mips/kernel/reset.c
> index 07fc524..c3391d7 100644
> --- a/arch/mips/kernel/reset.c
> +++ b/arch/mips/kernel/reset.c
> @@ -41,4 +41,6 @@ void machine_power_off(void)
>  {
>  	if (pm_power_off)
>  		pm_power_off();
> +	else
> +		do_kernel_poweroff();

I'm happy with this as long as in a later version pm_power_off indeed
goes away.

  Ralf
