Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3KUXTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:19:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3KUXTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:19:36 -0500
Message-ID: <528E94D1.2050809@zytor.com>
Date: Thu, 21 Nov 2013 15:18:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Jerry Hoemann <jerry.hoemann@hp.com>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        matt.fleming@intel.com, yinghai@kernel.org, akpm@linux-foundation.org,
        bp@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, penberg@kernel.org,
        mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com> <20131121230744.GA31592@srcf.ucam.org>
In-Reply-To: <20131121230744.GA31592@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 03:07 PM, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 02:01:24PM -0700, Jerry Hoemann wrote:
>>
>> Some platform have firmware that violates the UEFI spec and access boot
>> service code or data segments after the system has called ExitBootServices().
>> The call to efi_reserve_boot_services in setup_arch is a workaround to
>> avoid using boot service memory until after the kernel has done
>> SetVirtualAddressMap.  However, this reservation fragments memory
>> which can cause large allocations early in boot (e.g. crash kernel)
>> to fail.
> 
> This is a problem we have to solve, but I don't think this is the right 
> way to solve it. Why do we not just reattempt to perform the allocation 
> immediately after we've freed the boot services regions?
> 

Wouldn't the memory map already have gotten scrambled all to hell by then?

	-hpa

