Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaKMGsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:48:43 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:51302 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaKMGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:48:42 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2014 01:48:42 EST
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-LoopCount0:X-IronPort-AV:From:To:CC:Date:Subject:
   Thread-Topic:Thread-Index:Message-ID:References:
   In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version:
   Return-Path;
  b=mpZoa7x/O/oZuHzfxe+KdFnTgQZLmXmDa/uQ6Y20cUV+vbDJ/KIUmhoD
   hnZ1weg75uwhmVj351OHY0v6hQGOC7UcybBnpAaykUTuYu2Zc1W7eIruQ
   MeDeoaucIWf7OlY3j+fbL2j9ZIMDzfZZSaGXHBAwcQPI2xjPuTkaDGoM6
   E=;
X-LoopCount0: from 10.170.28.41
X-IronPort-AV: E=Sophos;i="5.07,375,1413262800"; 
   d="scan'208";a="588141132"
From: <B_B_Singh@DELL.com>
To: <bp@suse.de>, <stuart.w.hayes@gmail.com>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <matt.fleming@intel.com>
Date: Thu, 13 Nov 2014 12:09:02 +0530
Subject: RE: [PATCH] x86: Configure NX support earlier in setup_arch
Thread-Topic: [PATCH] x86: Configure NX support earlier in setup_arch
Thread-Index: Ac//CzZQXdNuppSdTyCFUyd6BrR/hgAARa7A
Message-ID: <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com>
 <53BC72D8.4090705@zytor.com> <53BDE4BD.50605@gmail.com>
 <20140714172225.GE25120@pd.tnic>
In-Reply-To: <20140714172225.GE25120@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD6mnOD021832

Hi Boris,

I feel this can be a valid scenario where user wants to disable the memory protection (NX flag disable) for his requirement, in that case he will hit this issue.
So request you to please revisit this patch.

Regards
Balaji Singh

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Borislav Petkov
Sent: Monday, July 14, 2014 10:52 PM
To: Stuart Hayes
Cc: H. Peter Anvin; tglx@linutronix.de; mingo@redhat.com; x86@kernel.org; linux-kernel@vger.kernel.org; matt.fleming@intel.com; bp@suse.de
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch

On Wed, Jul 09, 2014 at 07:56:29PM -0500, Stuart Hayes wrote:
> Well... I got this issue because a co-worker tripped over it. He had 
> NX disabled in BIOS for some reason, and found that linux wouldn't 
> boot--it hung right after grub2. I guess it took a while to figure out 
> that it was the fact that NX was disabled that caused linux not to 
> come up--and that could happen to other people. I don't know of any 
> real-world scenarios in which someone would actually prefer to run a 
> recent linux kernel with NX disabled, though.
>
> It looks like some of the other boot paths into the kernel 
> automatically clear the XD_DISABLE bit in the MISC_ENABLE MSR in the 
> CPU (in verify_cpu), but that doesn't happen when grub2 jumps to
> startup_64 in arch/x86/boot/compressed/head_64.S. I guess instead of 
> this patch, I could try to make a patch that turns NX back on 
> (somewhere in startup_64), but since the kernel already supports NX 
> being disabled, so I thought maybe just fixing that would be better. I 
> didn't like seeing the kernel just die without giving any indication 
> of what the problem is.

Well, hpa and I were talking about this briefly and this NX disabling in the BIOS is probably for some broken legacy applications/OSes. Linux enables NX unconditionally very early because disabling it is a very bad idea anyway, security-wise.

So, if this is just a random trip over of a co-worker and doesn't have any sensible use case, I'd rather leave it as is an don't fix it at all.

--
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
