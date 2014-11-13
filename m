Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaKMKaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:30:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:16364 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429AbaKMKaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:30:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,376,1413244800"; 
   d="scan'208";a="190882623"
Message-ID: <54648833.6020407@citrix.com>
Date: Thu, 13 Nov 2014 10:30:11 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 2/3] x86: allow dma_get_required_mask() to
 be overridden
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com> <1415805906-27316-3-git-send-email-david.vrabel@citrix.com> <546495280200007800047203@mail.emea.novell.com>
In-Reply-To: <546495280200007800047203@mail.emea.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 10:25, Jan Beulich wrote:
>>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
>> --- a/arch/x86/include/asm/device.h
>> +++ b/arch/x86/include/asm/device.h
>> @@ -13,4 +13,6 @@ struct dev_archdata {
>>  struct pdev_archdata {
>>  };
>>  
>> +#define ARCH_HAS_DMA_GET_REQUIRED_MASK
> 
> Is there a particular reason you put this here rather than in
> dma-mapping.h?

I was because asm/dma-mapping is included too late for it to work, but
looking at the current code it looks like it ought to work.

David
