Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaEMGXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:23:39 -0400
Received: from ozlabs.org ([103.22.144.67]:38280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaEMGXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:23:38 -0400
Message-ID: <1399962216.7554.63.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH] powerpc/pseries: relocate "config DTL" so KConfig nests
 properly
From: Michael Neuling <mikey@neuling.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Paul Bolle <pebolle@tiscali.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 May 2014 16:23:36 +1000
In-Reply-To: <1399950599-24826-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1399950599-24826-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> powerpc/pseries: relocate "config DTL" so KConfig nests properly

I don't know what that means.  Can you describe it in more detail?

Mikey


On Mon, 2014-05-12 at 20:09 -0700, Cody P Schafer wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/Kconfig | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index 2cb8b77..e00dd4d 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -33,6 +33,16 @@ config PPC_SPLPAR
>  	  processors, that is, which share physical processors between
>  	  two or more partitions.
>  
> +config DTL
> +	bool "Dispatch Trace Log"
> +	depends on PPC_SPLPAR && DEBUG_FS
> +	help
> +	  SPLPAR machines can log hypervisor preempt & dispatch events to a
> +	  kernel buffer. Saying Y here will enable logging these events,
> +	  which are accessible through a debugfs file.
> +
> +	  Say N if you are unsure.
> +
>  config PSERIES_MSI
>         bool
>         depends on PCI_MSI && PPC_PSERIES && EEH
> @@ -122,13 +132,3 @@ config HV_PERF_CTRS
>  	  systems. 24x7 is available on Power 8 systems.
>  
>            If unsure, select Y.
> -
> -config DTL
> -	bool "Dispatch Trace Log"
> -	depends on PPC_SPLPAR && DEBUG_FS
> -	help
> -	  SPLPAR machines can log hypervisor preempt & dispatch events to a
> -	  kernel buffer. Saying Y here will enable logging these events,
> -	  which are accessible through a debugfs file.
> -
> -	  Say N if you are unsure.

