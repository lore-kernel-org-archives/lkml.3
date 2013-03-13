Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3CMHw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:52:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:41646 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3CMHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:52:26 -0400
Message-ID: <51403036.3030702@openvz.org>
Date: Wed, 13 Mar 2013 11:52:22 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [ 069/100] e1000e: fix pci-device enable-counter balance
References: <20130312223122.884099393@linuxfoundation.org> <20130312223130.360294627@linuxfoundation.org>
In-Reply-To: <20130312223130.360294627@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

Vivek Goyal reported about problem caused by this improper fix.

https://lkml.org/lkml/2013/3/12/529

(this patch also pending to 3.0-stable and 3.4-stable)

>
> ------------------
>
> From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> commit 4e0855dff094b0d56d6b5b271e0ce7851cc1e063 upstream.
>
> This patch removes redundant and unbalanced pci_disable_device() from
> __e1000_shutdown(). pci_clear_master() is enough, device can go into
> suspended state with elevated enable_cnt.
>
> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Cc: Bruce Allan<bruce.w.allan@intel.com>
> Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> Tested-by: Borislav Petkov<bp@suse.de>
> Tested-by: Aaron Brown<aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5549,7 +5549,7 @@ static int __e1000_shutdown(struct pci_d
>   	 */
>   	e1000e_release_hw_control(adapter);
>
> -	pci_disable_device(pdev);
> +	pci_clear_master(pdev);
>
>   	return 0;
>   }
>
>

