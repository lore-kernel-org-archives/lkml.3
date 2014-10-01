Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJAUDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:03:53 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:63650 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJAUDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <542BB1AF.3060501@ti.com>
References: <20140930183731.GC3907@piout.net> <542BB1AF.3060501@ti.com>
From: =?UTF-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau.dev@gmail.com>
Date: Wed, 1 Oct 2014 22:03:31 +0200
Message-ID: <CA+sos7-0dBndvU_5J5d=GNtLz1MbCwGCRVDZ5K6sxD=9Qi0YuQ@mail.gmail.com>
Subject: Re: Differences between tlv320aic3x and tlv320aic31xx
To: Jyri Sarha <jsarha@ti.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alsa-devel <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre, Jyri,

On Wed, Oct 1, 2014 at 9:47 AM, Jyri Sarha <jsarha@ti.com> wrote:
> On 09/30/2014 09:37 PM, Alexandre Belloni wrote:
>>
>> Hi,
>>
>> I'm trying to add support for the tlv320aic3104a present on a
>> custom board using an am335x.
>>
>> I see that Benoit seemed to have been successful when using the
>> tlv320aic3x driver with minor modifications.
>>
>> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-January/058966.html
>>
>> On the other hand, in the past, I've used a tlv320aic3100 with the
>> tlv320aic31xx driver.
>>
>> My plan for now is to use the tlv320aic3x driver with snd-soc-evm as
>> this is the one it is using (it is using .codec_dai_name =
>> "tlv320aic3x-hifi").
>>
>> I had no luck until now but I still have to review my pinmuxing. But
>> before I investigate to much, can you confirm what codecs are supported
>> by which driver? I'm pretty sure that would be a nice addition to the
>> documentation too.
>> 0
>
>
> Hi Alexandre,
> Based on a brief look at the data sheet I am afraid you will not have any
> luck using tlv320aic3x driver with tlv320aic3104. tlv320aic31xx is a better
> match, but sill not close enough.
>
> Based on the register map you may have a change to get the codec working
> using tlv320aic32x4 driver. At least the register map appears to be a pretty
> good match. However, I have no experience either with the driver or the
> codec.

I've seen that the tlv320aic31xx driver has been available for some
time now, but I've not yet looked into it. However, the tlv320aic3x
driver works pretty well with the tlv320aic3104 (at least, it did at
the time of my post that you referred to). I've used it connected to a
Freescale i.MX25 through I²S. IIRC, the register map of the
tlv320aic3104 is just a subset of what this driver provides (apart
from the unimplemented register page, which I had added support for
locally, but I have not sent my patches yet), and there is some
renaming, especially for the I/Os (see the comment in the header of
this driver). I had also improved some audio controls, but I'm not
sure if this was required for the tlv320aic3104, or if it was just an
improvement also applicable to other CODECs supported by this driver.

I agree that some clarification would be required ergarding the
aic31xx CODECs those two drivers support. It may also be possible to
merge the 31xx driver into the 3x one.

Best regards,
Benoît
