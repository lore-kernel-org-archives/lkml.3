Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbaJaIfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:35:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaJaIff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:35:35 -0400
Date: Fri, 31 Oct 2014 09:35:30 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        <linux-kernel@vger.kernel.org>, neelegup@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] hwmon: (ibmpowernv) Make the driver name more
 recognisable
Message-ID: <20141031093530.2deb46e5@endymion.delvare>
In-Reply-To: <1414737923-8227-2-git-send-email-mpe@ellerman.id.au>
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au>
	<1414737923-8227-2-git-send-email-mpe@ellerman.id.au>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, 31 Oct 2014 17:45:23 +1100, Michael Ellerman wrote:
> Seeing "ibmpowernv" in dmesg is not very useful, that is just the name
> of the platform and doesn't identify the message as coming from the
> hwmon driver.
> 
> Change DRVNAME to "powernv-hwmon" to make it clearer.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/hwmon/ibmpowernv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
> index 6a30eeea94be..3ee00928cda9 100644
> --- a/drivers/hwmon/ibmpowernv.c
> +++ b/drivers/hwmon/ibmpowernv.c
> @@ -16,7 +16,7 @@
>   * along with this program.
>   */
>  
> -#define DRVNAME		"ibmpowernv"
> +#define DRVNAME		"powernv-hwmon"
>  #define pr_fmt(fmt)	DRVNAME ": " fmt
>  
>  #include <linux/init.h>

Nack. For one thing, DRVNAME is used for
devm_hwmon_device_register_with_groups and dashes are not allowed in
the name attribute. For another, making the driver name different from
the module name makes things more confusing, not clearer.

Like it or not, almost no hwmon driver has hwmon in its name anyway.

-- 
Jean Delvare
SUSE L3 Support
