Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaAWSIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:08:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaAWSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:08:19 -0500
Message-ID: <52E15AAE.4090106@oracle.com>
Date: Thu, 23 Jan 2014 13:08:46 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
References: <52DE94A9.9060505@oracle.com> <20140121161438.GD9004@pd.tnic> <52DEB4A9.4070707@oracle.com> <20140121182554.GE9004@pd.tnic>
In-Reply-To: <20140121182554.GE9004@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:25 PM, Borislav Petkov wrote:
> On Tue, Jan 21, 2014 at 12:55:53PM -0500, Boris Ostrovsky wrote:
>>          cat $(AMD_UCODE_PATH)/* >
>> ucode_initrd/kernel/x86/microcode/AuthenticAMD.bin
>>          (cd ucode_initrd;find . | cpio -o -H newc >
>> ../$(DISTDIR)/common/ucode_initrd.cpio)
>>          ...
>>          cat $(DISTDIR)/common/ucode_initrd.cpio \
>>              $(DISTDIR)/common/_initramfs.cpio.gz > \
>>              $(DISTDIR)/common/initramfs.cpio.gz
>>
>> and as I just discovered, with a little twist: apparently
>> AMD_UCODE_PATH points to Intel microcode.
> LOL!
>
> @hpa: in case you were wondering whether Intel ucode works on AMD - it
> doesn't! :-)
>
>> So we clearly screwed up on our end but I'd think that we shouldn't
>> crash when this happens.
> Yes, we shouldn't. I'll try to reproduce it here.

So I tried this on a "good" system and I am pretty sure this is broken. 
I don't
have any microcode in initrd and I am still dying in load_microcode_amd().

I didn't dig any further but if you can't reproduce this I can look at 
what is
a NULL and why. (I suspect it's the 'container' variable).

-boris
