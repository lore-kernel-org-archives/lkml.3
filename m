Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaDBPtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:49:10 -0400
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:33803 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758751AbaDBPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <533C0B45.4050909@ti.com>
References: <20140401184916.GA21938@kroah.com>
	<CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
	<20140402022858.GA4901@kroah.com>
	<CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
	<533C0B45.4050909@ti.com>
Date: Wed, 2 Apr 2014 08:49:07 -0700
Message-ID: <CAPw-ZTn3_oEMFFNua1zoDibOBJOLC92k7zdc8Do+hk3Ai-BSaw@mail.gmail.com>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
From: Loc Ho <lho@apm.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>>>> USB patches for 3.15-rc1
>>>>>
>>>>> Here's the big USB pull request for 3.15-rc1.
>>>>
>>>> Hmm. I'm getting this when testing:
>>>>
>>>>   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
>>>> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
>>>>
>>>> which looks like AHCI_XGENE doesn't have the proper dependency on OF
>>>> (or alternatively PHY_XGENE has an incorrect dependemcy on OF).
>>>>
>>>> According to google it looks like Fengguang reported this on
>>>> kbuild-all, but nowhere else.
>>>>
>>>> The actual build then succeeds. But the Kconfig warning is real and
>>>> implies that something is seriously wrong wrt the dependencies for
>>>> this thing.
>>>>
>>>> It looks like the "select PHY_XGENE" came in through the libata
>>>> update, but this USB update actually brought in the "config PHY_XGENE"
>>>> and thus this error. Which makes me wonder how this all worked. Why
>>>> does that "select PHY_XGENE" exist when apparently it's not needed?
>>>>
>>>> Regardless, there's something broken somewhere.
>>>
>>> Odd, I don't know what to do to fix this up "properly".
>>>
>>> Loc Ho, this came in from your patch, any ideas?
>
> Shouldn't we let the users to enable PHY_XGENE (maybe add in the platform
> defconfig)?
>

This is another option but PHY_XGENE is required by AHCI_XGENE . If
one selects AHCI_XGENE, it should select its dependency.

-Loc
