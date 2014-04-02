Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbaDBFmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:42:20 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:37505 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757318AbaDBFmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140402022858.GA4901@kroah.com>
References: <20140401184916.GA21938@kroah.com>
	<CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
	<20140402022858.GA4901@kroah.com>
Date: Tue, 1 Apr 2014 22:42:12 -0700
Message-ID: <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
From: Loc Ho <lho@apm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> > USB patches for 3.15-rc1
>> >
>> > Here's the big USB pull request for 3.15-rc1.
>>
>> Hmm. I'm getting this when testing:
>>
>>   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
>> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
>>
>> which looks like AHCI_XGENE doesn't have the proper dependency on OF
>> (or alternatively PHY_XGENE has an incorrect dependemcy on OF).
>>
>> According to google it looks like Fengguang reported this on
>> kbuild-all, but nowhere else.
>>
>> The actual build then succeeds. But the Kconfig warning is real and
>> implies that something is seriously wrong wrt the dependencies for
>> this thing.
>>
>> It looks like the "select PHY_XGENE" came in through the libata
>> update, but this USB update actually brought in the "config PHY_XGENE"
>> and thus this error. Which makes me wonder how this all worked. Why
>> does that "select PHY_XGENE" exist when apparently it's not needed?
>>
>> Regardless, there's something broken somewhere.
>
> Odd, I don't know what to do to fix this up "properly".
>
> Loc Ho, this came in from your patch, any ideas?

I don't think it has anything to do with USB. With the current
dependency, X-Gene SATA AHCI driver will be included if either ARM64
or COMPILE_TEST. It in turn will select "PHY_XGENE" which has
dependency on OF and HAS_IOMEM. An fix would be make AHCI_XGENE
depends on OF as suggested by Linus. This is trigger by "COMPILE_TEST"
for non-ARM64. We can also remove "COMPILE_TEST" from AHCI_XGENE
driver like other SATA drivers. My prefer solution is to remove
"COMPILE_TEST".

-Loc
