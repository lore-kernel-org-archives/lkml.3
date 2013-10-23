Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3JWCvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:51:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:51615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3JWCvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:51:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311378154"
Message-ID: <5267393E.1070503@linux.intel.com>
Date: Tue, 22 Oct 2013 19:49:34 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: "Yang, Fei" <fei.yang@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Mark F" <mark.f.brown@intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH] x86: intel-mid: add Merrifield platform support
References: <1382131130-10903-4-git-send-email-david.a.cohen@linux.intel.com> <1382484820-5912-1-git-send-email-david.a.cohen@linux.intel.com> <02E7334B1630744CBDC55DA85862258348EDC9B0@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <02E7334B1630744CBDC55DA85862258348EDC9B0@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 05:49 PM, Yang, Fei wrote:
> +				if (intel_mid_identify_cpu() ==
> +						INTEL_MID_CPU_CHIP_TANGIER) {
> +					if (!strncmp(pentry->name,
> +							"r69001-ts-i2c", 13))
> +						/* active low */
> +						irq_attr.polarity = 1;
> +					else if (!strncmp(pentry->name,
> +							"synaptics_3202", 14))
> +						/* active low */
> +						irq_attr.polarity = 1;
> +					else if (irq == 41)
> +						/* fast_int_1 */
> +						irq_attr.polarity = 1;
>
> Do you really want to upstream these very hardware specific hacks? It's needed for
> Saltbay, but might not be correct for other Merrifield based hardware, if any.

At this very initial moment we do want to support saltbay, which is the
main reference for Merrifield. So we can't run away from the ugly hack :)
Later, when we upstream the support to detect specific intel mid board
details, this code will be isolated for saltbay (and maybe other
required boards) and won't affect Merrifield in general.

Br, David Cohen

