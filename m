Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaDBNGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:06:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758676AbaDBNGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:06:22 -0400
Message-ID: <533C0B45.4050909@ti.com>
Date: Wed, 2 Apr 2014 18:36:13 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Loc Ho <lho@apm.com>, Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
References: <20140401184916.GA21938@kroah.com>	<CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>	<20140402022858.GA4901@kroah.com> <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
In-Reply-To: <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 02 April 2014 11:12 AM, Loc Ho wrote:
> Hi,
> 
>>>> USB patches for 3.15-rc1
>>>>
>>>> Here's the big USB pull request for 3.15-rc1.
>>>
>>> Hmm. I'm getting this when testing:
>>>
>>>   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
>>> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
>>>
>>> which looks like AHCI_XGENE doesn't have the proper dependency on OF
>>> (or alternatively PHY_XGENE has an incorrect dependemcy on OF).
>>>
>>> According to google it looks like Fengguang reported this on
>>> kbuild-all, but nowhere else.
>>>
>>> The actual build then succeeds. But the Kconfig warning is real and
>>> implies that something is seriously wrong wrt the dependencies for
>>> this thing.
>>>
>>> It looks like the "select PHY_XGENE" came in through the libata
>>> update, but this USB update actually brought in the "config PHY_XGENE"
>>> and thus this error. Which makes me wonder how this all worked. Why
>>> does that "select PHY_XGENE" exist when apparently it's not needed?
>>>
>>> Regardless, there's something broken somewhere.
>>
>> Odd, I don't know what to do to fix this up "properly".
>>
>> Loc Ho, this came in from your patch, any ideas?

Shouldn't we let the users to enable PHY_XGENE (maybe add in the platform
defconfig)?

Thanks
Kishon
