Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3LMQ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:59:01 -0500
Received: from host217-34-137-81.in-addr.btopenworld.com ([217.34.137.81]:41468
	"EHLO external.sentinel2" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431Ab3LMQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:59:00 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2013 11:59:00 EST
Message-ID: <52AB3B64.3000709@bobich.net>
Date: Fri, 13 Dec 2013 16:52:52 +0000
From: Gordan Bobic <gordan@bobich.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Xen PCI back - do slot and bus reset (v0).
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 04:09 PM, Konrad Rzeszutek Wilk wrote:
> Hey,
>
> While I was trying to narrow down the state of GPU passthrough
> (still not finished) and figuring what needs to be done I realized
> that Xen PCIback did not reset my GPU properly (when I crashed the
> Windows guest by mistake). It does an FLR reset or Power one - if
> the device supports it. But it seems that some of these GPUs
> are liars and actually don't do the power part properly.

Some cards (IIRC Fermi based Nvidia cards) support neither the required 
power states nor FLR, although you can use setpci to force a powered off 
state on the card without an error being triggered. Unfortunately, it 
seems to be a null operation, and the card doesn't end up getting reset.

> One way to fix this is by doing a slot (aka device) and bus reset.
> Of course to do that - you need to make sure that all of the
> functions of a device are under the ownership of xen-pciback.
> Otherwise you might accidently reset your sound card while it is
> being used.
 >
> These RFC patches cleanup pci back a bit and also make it possible
> for Xen pciback to do the whole gamma of 'reset' for PCI devices:
> FLR, power management, AER, slot and bus reset if neccessary.
>
> Thanks go to Gordan Bobic for educating me on how to "reprogram"
> and GFX460 in a Quardro 4000M and also reporting oddities when
> a PCI device was reset but it looked like it was not reset.

You're welcome. :)

Gordan

