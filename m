Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3FWOIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 10:08:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40484 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3FWOH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 10:07:59 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51C69732.1010906@gmail.com>
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: MTRR use in drivers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Jun 2013 07:07:46 -0700
To: Brice Goglin <brice.goglin@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Message-ID: <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why do you care about performance when PAT is disabled?

Brice Goglin <brice.goglin@gmail.com> wrote:

>Le 21/06/2013 07:00, H. Peter Anvin a écrit :
>> An awful lot of drivers, mostly DRI drivers, are still mucking with
>> MTRRs directly as opposed to using ioremap_wc() or similar
>interfaces.
>> In addition to the architecture dependency, this is really
>undesirable
>> because MTRRs are a limited resource, whereas page table attributes
>are not.
>>
>> Furthermore, this perpetuates the need for the horrific hack known as
>> "MTRR cleanup".
>>
>> What, if anything, can we do to clean up this mess?
>>
>> 	-hpa
>>
>
>The first network driver that used ioremap_wc() back in 2008 (myri10ge)
>had to keep using MTRR because ioremap_wc() silently falls back to
>ioremap_nocache() when PAT is disabled.
>
>I asked about this in https://lkml.org/lkml/2008/5/31/42 and there was
>some talk about putting the MTRR addition in the nocache fallback path
>but I guess nobody implemented the idea.
>
>Brice

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
