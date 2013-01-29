Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3A2BMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:12:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3A2BM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:12:29 -0500
Message-ID: <510721C6.6080705@zytor.com>
Date: Mon, 28 Jan 2013 17:11:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump
 usage
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com> <CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com> <6950516.1uefDuthAH@hammer82.arch.suse.de>
In-Reply-To: <6950516.1uefDuthAH@hammer82.arch.suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 05:05 PM, Thomas Renninger wrote:
> 
> But this (converting usable memory to reserved one before usable kdump memory
> is added) will let machines run into problems again for which the check:
> "mmconf area must be in reserved memory" got added?
> 
> If, then memory which was usable before has to be converted to a special
> E820_KUMP (or whatever type) to make sure existing checks which look for
> "is reserved memory" still work the same way as in a productive kernel.
> 
> Advantage of this would be that the info what originally was usable
> memory is preserved and can be used in future kdump related patches.
> 
> So I guess the final patch should be:
>    - Add a new e820 type:
>         E820_KDUMP_RESERVED /* Originally usable memory where the crashed
>                                                     kernel kernel resided in */
>   - Use Yinghai's last posted patch, but instead of:
> +			e820_update_range(0, ULLONG_MAX, E820_RAM,
> +					  E820_RESERVED);
> ...
> +			e820_remove_range(start_at, mem_size, E820_RESERVED, 0);
> do:
> +			e820_update_range(0, ULLONG_MAX, E820_RAM,
> +					  E820_KDUMP_RESERVED);
> ...
> +			e820_remove_range(start_at, mem_size, E820_KDUMP_RESERVED, 0);
> 
>   - Come up with another memmap=kdump_reserve_ram memmap option name
>     or however it should get named...
> 
> If this proposal gets accepted, I can send a tested patch...
> 

Yes, this is much saner.  There really shouldn't need to be an option,
even; since the tools need to be modified anyway, just modify the actual
memory map data structure itself.

	-hpa


