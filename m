Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaFHKgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:36:14 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:65379 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaFHKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <1436639.AmJiDmeQZF@al>
References: <1402151419-18296-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CAFo99gZ+iu3FA9Nuwdo_AT1xZkno7w=6JidWYcm8g0bOvshwTw@mail.gmail.com>
	<5393A7D0.2080700@lwfinger.net>
	<1436639.AmJiDmeQZF@al>
Date: Sun, 8 Jun 2014 12:36:11 +0200
Message-ID: <CAFo99gb2gzLjv_4b3O-e0B1R8P5BTGbPJLuYYAmoyww9hkmrvA@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: hw.c: Cleaning up
 conjunction always evaluates to false
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Damn, there I was bit too fast :-(

Then we use MSR_MASK instead, new patch then. But I will wait a day?
Or what is long enough to be sure that nobody else have any
objections? How is this usually resolved?

Sure, I can send a patch for all the files instead. However, earlier
received complaints when I sent patches extending over more than one
file.

I'll check again how the cover letter works. Although when I try with
my send patch mail script it did not work as I wanted.


Best regards
Rickard Strandqvist


2014-06-08 11:26 GMT+02:00 Peter Wu <peter@lekensteyn.nl>:
> On Saturday 07 June 2014 19:01:20 Larry Finger wrote:
>> As you have learned here, automatically making changes suggested by some tool
>> may convert a visible bug into one that is invisible, and only found by a
>> detailed line-by-line examination of the code, and that is unlikely to happen.
>> Please be careful.
>>
>>  From everything I see, the test in all drivers should be
>>
>>         if ((bt_msr & MSR_AP) == MSR_AP)
>
> That only happens to be case because MSR_INFRA | MSR_ADHOC == MSR_AP. This
> seems to be the intent:
>
>     #define MSR_MASK 0x03
>     if ((bt_msr & MSR_MASK) == MSR_AP)
>
> In rtl8192se, there are also MSR_LINK_... constants covering MSR_...
> and in addition, there is a MSR_LINK_MASK. These macros are quite
> redundant though given the other definitions, but the mask is still
> nice to have I guess.
>
> Also, personally I would submit just one patch touching all drivers, but
> I see that Rickard has submitted a bunch of patches (without cover letter
> either, making it more difficult to group them). What would you prefer,
> a single patch touching multiple drivers (as the changes are mostly the
> same) or split patches?
>
> Kind regards,
> Peter
>
