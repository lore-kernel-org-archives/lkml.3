Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3H2OVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:21:41 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:45172
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788Ab3H2OVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:21:40 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z551bizbb2dI98dI9371I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh19b6n1155h192ch)
Date: Thu, 29 Aug 2013 16:21:28 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-17-git-send-email-sebastian.hesselbarth@gmail.com> <201308291537.54608.arnd@arndb.de>
In-Reply-To: <201308291537.54608.arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <89b68978-7eeb-43e1-a456-d864ed313da5@DB8EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 03:37 PM, Arnd Bergmann wrote:
> On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
>> @@ -58,10 +57,10 @@ static void __init zynq_init_machine(void)
>>         of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
>>  }
>>  
>> -static void __init zynq_timer_init(void)
>> +static void __init zynq_init_irq(void)
>>  {
>> +       irqchip_init();
>>         zynq_slcr_init();
>> -       clocksource_of_init();
>>  }
>>  
>>  static struct map_desc zynq_cortex_a9_scu_map __initdata = {
>> @@ -104,8 +103,8 @@ static const char * const zynq_dt_match[] = {
>>  DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>>         .smp            = smp_ops(zynq_smp_ops),
>>         .map_io         = zynq_map_io,
>> +       .init_irq       = zynq_init_irq,
>>         .init_machine   = zynq_init_machine,
>> -       .init_time      = zynq_timer_init,
>>         .dt_compat      = zynq_dt_match,
>>         .restart        = zynq_system_reset,
>>  MACHINE_END
> 
> It looks like we are not getting any closer to removing all callbacks here,
> since you add one in order to remove another, and after the patch we do
> more things "early", which we try to avoid. I think we're better off without
> this particular patch.

Is there any plan to remove all of them?
I expect that on almost all platforms it is a need to have at least one
early hook to be able to setup things.

Thanks,
Michal


