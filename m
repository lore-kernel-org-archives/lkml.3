Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3CJTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 15:50:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53499 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab3CJTuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 15:50:25 -0400
X-Sasl-enc: kElMq0lnrp+YoOhcqPDnJ5POnPWZMwuZcHMVrDGCLMyF 1362945023
Message-ID: <513CE3B8.9020308@ladisch.de>
Date: Sun, 10 Mar 2013 20:49:12 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Vicentiu Ciorbaru <cvicentiu@gmail.com>
CC: perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] emu10k1: Fix coccicheck warning
References: <1362919067-17250-1-git-send-email-cvicentiu@gmail.com>	<513CB587.5010304@ladisch.de> <CACzaYTOE=tVst3=TvUCtxpMuUOtJiHQ3o2wbgWeMvxwZy41DMw@mail.gmail.com>
In-Reply-To: <CACzaYTOE=tVst3=TvUCtxpMuUOtJiHQ3o2wbgWeMvxwZy41DMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vicentiu Ciorbaru wrote:
> On Sun, Mar 10, 2013 at 6:32 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> Vicentiu Ciorbaru wrote:
>>> Removed redundant cast of kmalloc return pointer.
>>
>>> -         (icode->gpr_map = (u_int32_t __user *)
>>> -          kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
>>> -                  GFP_KERNEL)) == NULL ||
>>> +         (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024,
>>> +                             sizeof(u_int32_t), GFP_KERNEL)) == NULL ||
>>
>> Why would casting to __user be redundant?
>
> My reasoning behind the patch is that the C standard does not require a
> specific cast of a void pointer in order to set it to the type of the
> member gpr_map of the struct snd_emu10k1_fx8010_code. I named it redundant
> because the compiler would cast to it anyway.

That's correct as far as the C standard is concerned.  However, __user is
a non-standard extension.

> The line also appears as a warning when running make coccicheck.

And when you remove the __user, you get a warning when running make C=x.

Both coccinelle and sparse are merely tools for finding likely bugs.
When it isn't possible to make them both happy with or without the cast,
that just shows that the code itself is badly designed.

The driver should be redesigned to not access user and kernel space
memory through the same pointer.


Regards,
Clemens
