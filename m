Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3GOCca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:32:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37018 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3GOCc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:32:29 -0400
Message-ID: <51E35F31.1040709@hp.com>
Date: Mon, 15 Jul 2013 10:32:17 +0800
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@kernel.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130709 DMAR issues
References: <29624.1373475702@turing-police.cc.vt.edu> <20130712121419.GA22945@gmail.com> <20130712143122.GF28811@8bytes.org>
In-Reply-To: <20130712143122.GF28811@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have met a bug with the same error message, its cause was that the bios
did not allocate RMRR/DRHD(can't remember which one) for the device.

Thanks
ZhenHua

On 07/12/2013 10:31 PM, Joerg Roedel wrote:
> Thanks for the heads-up, Ingo.
>
> On Fri, Jul 12, 2013 at 02:14:20PM +0200, Ingo Molnar wrote:
>>> Jul 10 12:20:19 turing-police kernel: [    0.021583] DMAR:[fault reason 06] PTE Read access is not set
>>>
>>> Now I have 3 extra messages talking about handling a fault status.  lspci says 00:1f.2 is:
>>>
>>> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
> This could be caused by some change in the SATA driver stack. Maybe a
> DMA buffer is used after unmap or something.
>
>
>>> If this doesn't ring any bells, I'l go do the bisect thing...
> Yes, a bisection would help here, thanks for doing this.
>
>
> 	Joerg
>
>
> .
>

