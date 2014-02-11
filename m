Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaBKQTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:19:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60209 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBKQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:19:17 -0500
Date: Tue, 11 Feb 2014 17:19:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ak@linux.intel.com, zheng.z.yan@intel.com
Subject: Re: [PATCH v2 6/8] perf/x86/uncore: add SNB/IVB/HSW client uncore
 memory controller support
Message-ID: <20140211161905.GS27965@twins.programming.kicks-ass.net>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
 <1392132015-14521-7-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392132015-14521-7-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:20:12PM +0100, Stephane Eranian wrote:
> This patch adds a new uncore PMU for Intel SNB/IVB/HSW client


> @@ -3501,6 +3844,28 @@ static int __init uncore_pci_init(void)
>  		pci_uncores = ivt_pci_uncores;
>  		uncore_pci_driver = &ivt_uncore_pci_driver;
>  		break;
> +	case 42: /* Sandy Bridge */
> +		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
> +		if (ret)
> +			return ret;
> +		pci_uncores = snb_pci_uncores;
> +		uncore_pci_driver = &snb_uncore_pci_driver;
> +		break;
> +	case 60: /* Haswell */
> +	case 69: /* Haswell Celeron */
> +		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
> +		if (ret)
> +			return ret;
> +		pci_uncores = snb_pci_uncores;
> +		uncore_pci_driver = &hsw_uncore_pci_driver;
> +		break;
> +	case 58: /* Ivy Bridge */
> +		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
> +		if (ret)
> +			return ret;
> +		pci_uncores = snb_pci_uncores;
> +		uncore_pci_driver = &ivb_uncore_pci_driver;
> +		break;
>  	default:
>  		return 0;
>  	}

I reorderd that list; but looking at perf_event_intel.c we have a lot
more HSW clients listed there. Plz as to make it consistent.
