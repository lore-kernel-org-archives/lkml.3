Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaCEMnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:43:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60961 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752250AbaCEMno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:43:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [ACPI / hotplug / PCI] 1b360f44d00: -80.9% vm-scalability.stddev
Date: Wed, 05 Mar 2014 13:58:54 +0100
Message-ID: <1530281.asBBpMI1MW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140305082336.GD17109@localhost>
References: <20140305082336.GD17109@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 04:23:36 PM Fengguang Wu wrote:
> Hi Rafael,

Hi,

> I don't know why but we are glad to find the below changes on commit

Do I understand correcty that you mean you're seeing improvement?

Either way, if the test below doesn't involve hotplug or device removal via
sysfs, I have no explanation ...

> 1b360f44d009059e446532f29c1a889951e72667 ("ACPI / hotplug / PCI: Fix bridge removal race in handle_hotplug_event()")
> 
> test case: brickland2/micro/vm-scalability/300s-anon-r-rand-mt
> 
> d42f5da23400833  1b360f44d009059e446532f29  
> ---------------  -------------------------  
>       3.54 ~164%     -80.9%       0.68 ~37% TOTAL vm-scalability.stddev
>      14177 ~ 7%     -22.1%      11040 ~ 7%  TOTAL numa-meminfo.node0.SReclaimable
>       3543 ~ 7%     -22.1%       2759 ~ 7%  TOTAL numa-vmstat.node0.nr_slab_reclaimable
>     776196 ~ 6%     -10.0%     698893 ~ 5%  TOTAL numa-numastat.node2.local_node
>     776196 ~ 6%     -10.0%     698894 ~ 5%  TOTAL numa-numastat.node2.numa_hit
> 
> The ~XX% numbers are stddev percent.
> The [+-]XX% is change percent.
> 
> The below graph shows all samples collected during the bisect
> 
> [*] bisect-good
> [O] bisect-bad ("bad" in the sense of bisect)
> 
> In which you can see the stableness of the change and bisect.
> 
>                                vm-scalability.stddev
> 
>    16 ++--------------------------------------------------------------------+
>       |                                                                 *   |
>    14 ++                                                                :   |
>    12 ++                                                                :   |
>       |                                                                 ::  |
>    10 ++                                                                ::  |
>       |                                                                 ::  |
>     8 ++                                                                ::  |
>       |                                                                : :  |
>     6 ++                                                    *          : :  |
>     4 ++           *      *                                 ::         :  : |
>       |           +:     : +                       *       : :         :  : |
>     2 ++*.   *. .*  :    :  *          .*.        + :      :  :   .*   :  : |
>       |+  * +  *    *. .* O  *.*.*. .**   O.**.O.* O: *.O.* O OO.*  +  :  *.|
>     0 O+O-OO-O-O-O-OO-O-O---OO-O-O-O-OO-O---OO-*-O---OO-*-O------O-O-*-*----*
> 
> 
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
