Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3H2Nid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:38:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3H2Nic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:38:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
Date: Thu, 29 Aug 2013 15:37:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-17-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1377638890-371-17-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291537.54608.arnd@arndb.de>
X-Provags-ID: V02:K0:SXU1CfkuAz7+7dpGwKe3ZXmQdh4kYonVepqp8hbvKYr
 e7oJnZFXwhLJV7uInT+DDpSq8D2K3f5cDBFXc1krGrpkIRVrnu
 EQtpMSilrtnGn+2LJtIY5hDPo6cfJcSpbSLa7GzatWIM8vwAk7
 Kw4xbSsxRbGXTyYy+VA4msdaJrrE7YIRZTMICJq8sItrumwTlM
 OlxOezUlW+kLUL7mG+pNhvJ45H+yX/raXRy6nj1RCXa/lrtHIx
 SsLXwS7NvS2tlwu0RxNHBYzULHpMUQFeT5sKO+4J64rujyq5Hy
 uEWuOkt0vxCXpbPtw6F5EoBUO/HHJGfQZhcn0bfyulNcflcnE0
 yaoqJ/nkL73L6LskBu0M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
> @@ -58,10 +57,10 @@ static void __init zynq_init_machine(void)
>         of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
>  }
>  
> -static void __init zynq_timer_init(void)
> +static void __init zynq_init_irq(void)
>  {
> +       irqchip_init();
>         zynq_slcr_init();
> -       clocksource_of_init();
>  }
>  
>  static struct map_desc zynq_cortex_a9_scu_map __initdata = {
> @@ -104,8 +103,8 @@ static const char * const zynq_dt_match[] = {
>  DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>         .smp            = smp_ops(zynq_smp_ops),
>         .map_io         = zynq_map_io,
> +       .init_irq       = zynq_init_irq,
>         .init_machine   = zynq_init_machine,
> -       .init_time      = zynq_timer_init,
>         .dt_compat      = zynq_dt_match,
>         .restart        = zynq_system_reset,
>  MACHINE_END

It looks like we are not getting any closer to removing all callbacks here,
since you add one in order to remove another, and after the patch we do
more things "early", which we try to avoid. I think we're better off without
this particular patch.

	Arnd
