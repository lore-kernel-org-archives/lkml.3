Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaAWTJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:09:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaAWTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:09:03 -0500
Message-ID: <52E168F7.7090709@oracle.com>
Date: Thu, 23 Jan 2014 14:09:43 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
References: <52DE94A9.9060505@oracle.com> <20140121182554.GE9004@pd.tnic> <52E15AAE.4090106@oracle.com> <201401231354.06952.gheskett@wdtv.com>
In-Reply-To: <201401231354.06952.gheskett@wdtv.com>
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 01:54 PM, Gene Heskett wrote:
> On Thursday 23 January 2014, Boris Ostrovsky wrote:
>> On 01/21/2014 01:25 PM, Borislav Petkov wrote:
>>> On Tue, Jan 21, 2014 at 12:55:53PM -0500, Boris Ostrovsky wrote:
>>>>           cat $(AMD_UCODE_PATH)/* >
>>>>
>>>> ucode_initrd/kernel/x86/microcode/AuthenticAMD.bin
>>>>
>>>>           (cd ucode_initrd;find . | cpio -o -H newc >
>>>>
>>>> ../$(DISTDIR)/common/ucode_initrd.cpio)
>>>>
>>>>           ...
>>>>           cat $(DISTDIR)/common/ucode_initrd.cpio \
>>>>           
>>>>               $(DISTDIR)/common/_initramfs.cpio.gz > \
>>>>               $(DISTDIR)/common/initramfs.cpio.gz
>>>>
>>>> and as I just discovered, with a little twist: apparently
>>>> AMD_UCODE_PATH points to Intel microcode.
>>> LOL!
>>>
>>> @hpa: in case you were wondering whether Intel ucode works on AMD - it
>>> doesn't! :-)
>>>
>>>> So we clearly screwed up on our end but I'd think that we shouldn't
>>>> crash when this happens.
>>> Yes, we shouldn't. I'll try to reproduce it here.
>> So I tried this on a "good" system and I am pretty sure this is broken.
>> I don't
>> have any microcode in initrd and I am still dying in
>> load_microcode_amd().
> You can find the code on AMD's web site if you look carefully, or at least
> I was able to some years ago when I built this box.  There s/b an installer
> that lives in /etc/init.d, and the code itself normally lives in the
> /lib/firmware/amd-ucode/ directory.
>
> If its working correctly you should see something resembling this in your
> dmsg with:
> gene@coyote$ grep microcode  /var/log/dmesg
> [   22.572212] microcode: CPU0: patch_level=0x01000065
> [   22.573242] microcode: CPU0: new patch_level=0x01000083
> [   22.573256] microcode: CPU1: patch_level=0x01000065
> [   22.573263] microcode: CPU1: new patch_level=0x01000083
> [   22.573273] microcode: CPU2: patch_level=0x01000065
> [   22.573281] microcode: CPU2: new patch_level=0x01000083
> [   22.573293] microcode: CPU3: patch_level=0x01000065
> [   22.573301] microcode: CPU3: new patch_level=0x01000083
> [   22.573377] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>
> That was from a bootup to 3.12.6, 32 bit PAE, on a quad core phenom.

Right. But the (suspected) regression is from this Monday's merge
of early microcode loading code.

-boris

