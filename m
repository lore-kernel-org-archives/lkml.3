Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaJGFWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:22:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:35560 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaJGFWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:22:35 -0400
Message-ID: <1412659338.30859.145.camel@pasglop>
Subject: Re: [PATCH v2 1/5] powerpc/powernv: Add OPAL call to save and
 restore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 07 Oct 2014 16:22:18 +1100
In-Reply-To: <1412149617-3178-2-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1412149617-3178-2-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 13:16 +0530, Shreyas B. Prabhu wrote:
> PORE can be programmed to restore hypervisor registers when waking up
> from deep cpu idle states like winkle.

Tell us a bit more about what "PORE" is. IE, explain a tiny engine will
reconfigure the core and its ucode can be patched to provide some
registers with sane values.

> Add call to pass SPR address and value to OPAL, which in turn will
> program PORE to restore the register state.

Otherwise, Acke-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Suggested-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/opal.h                | 2 ++
>  arch/powerpc/platforms/powernv/opal-wrappers.S | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
> index 166d572..d376020 100644
> --- a/arch/powerpc/include/asm/opal.h
> +++ b/arch/powerpc/include/asm/opal.h
> @@ -150,6 +150,7 @@ struct opal_sg_list {
>  #define OPAL_PCI_EEH_FREEZE_SET			97
>  #define OPAL_HANDLE_HMI				98
>  #define OPAL_CONFIG_IDLE_STATE			99
> +#define OPAL_SLW_SET_REG			100
>  #define OPAL_REGISTER_DUMP_REGION		101
>  #define OPAL_UNREGISTER_DUMP_REGION		102
>  
> @@ -978,6 +979,7 @@ extern int opal_handle_hmi_exception(struct pt_regs *regs);
>  extern void opal_shutdown(void);
>  extern int opal_resync_timebase(void);
>  int64_t opal_config_idle_state(uint64_t state, uint64_t enter);
> +int64_t opal_slw_set_reg(uint64_t cpu_pir, uint64_t sprn, uint64_t val);
>  
>  extern void opal_lpc_init(void);
>  
> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
> index 8d1e724..12e5d46 100644
> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
> @@ -246,5 +246,6 @@ OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
>  OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
>  OPAL_CALL(opal_handle_hmi,			OPAL_HANDLE_HMI);
>  OPAL_CALL(opal_config_idle_state,		OPAL_CONFIG_IDLE_STATE);
> +OPAL_CALL(opal_slw_set_reg,			OPAL_SLW_SET_REG);
>  OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
>  OPAL_CALL(opal_unregister_dump_region,		OPAL_UNREGISTER_DUMP_REGION);


