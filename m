Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CJT7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 15:59:15 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46688 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3CJT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 15:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <513CE3B8.9020308@ladisch.de>
References: <1362919067-17250-1-git-send-email-cvicentiu@gmail.com>
	<513CB587.5010304@ladisch.de>
	<CACzaYTOE=tVst3=TvUCtxpMuUOtJiHQ3o2wbgWeMvxwZy41DMw@mail.gmail.com>
	<513CE3B8.9020308@ladisch.de>
Date: Sun, 10 Mar 2013 21:59:13 +0200
Message-ID: <CACzaYTNGou67KhL5iRW8w2qViu2Q05TMdnUjmeSVebdYwS9g0A@mail.gmail.com>
Subject: Re: [PATCH] emu10k1: Fix coccicheck warning
From: Vicentiu Ciorbaru <cvicentiu@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> My reasoning behind the patch is that the C standard does not require a
>> specific cast of a void pointer in order to set it to the type of the
>> member gpr_map of the struct snd_emu10k1_fx8010_code. I named it redundant
>> because the compiler would cast to it anyway.
>
> That's correct as far as the C standard is concerned.  However, __user is
> a non-standard extension.
>
>> The line also appears as a warning when running make coccicheck.
>
> And when you remove the __user, you get a warning when running make C=x.
>
> Both coccinelle and sparse are merely tools for finding likely bugs.
> When it isn't possible to make them both happy with or without the cast,
> that just shows that the code itself is badly designed.
>
> The driver should be redesigned to not access user and kernel space
> memory through the same pointer.

In that case I thank you for the quick feedback and I will try looking
more deeply into the issue.

Vicentiu
