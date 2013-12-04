Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3LDXkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:40:13 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50179 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3LDXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:40:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131204232118.1c3db844@alan.etchedpixels.co.uk>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<20131204232118.1c3db844@alan.etchedpixels.co.uk>
Date: Wed, 4 Dec 2013 15:40:06 -0800
X-Google-Sender-Auth: J-vMKoYLxPWZxlvAjIRsoEZg-f8
Message-ID: <CAMbhsRQHRK8xRzff_vCeqUwp=VGkByxVijxHpYjsKhA_oB7C=A@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Colin Cross <ccross@android.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>, Ian Rogers <irogers@google.com>,
        romlem@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 3:21 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Wed, 4 Dec 2013 10:35:54 -0800
> Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Wed, Dec 04, 2013 at 06:09:41PM +0000, Serban Constantinescu wrote:
>> > +#define size_helper(x) ({                                              \
>> > +   size_t __size;                                                      \
>> > +   if (!is_compat_task())                                              \
>> > +           __size = sizeof(x);                                         \
>> > +   else if (sizeof(x) == sizeof(struct flat_binder_object))            \
>> > +           __size = sizeof(struct compat_flat_binder_object);          \
>> > +   else if (sizeof(x) == sizeof(struct binder_transaction_data))       \
>> > +           __size = sizeof(struct compat_binder_transaction_data);     \
>> > +   else if (sizeof(x) == sizeof(size_t))                               \
>> > +           __size = sizeof(compat_size_t);                             \
>> > +   else                                                                \
>> > +            BUG();                                                     \
>> > +   __size;                                                             \
>> > +   })
>>
>> Ick.
>>
>> First off, no driver should ever be able to crash the kernel, which you
>> just did.
>
> And which would appear to mean that this code hasn't actually been
> tested - at least not properly with error cases ?
>
> You talk about type safety too but your code is already full of
> "put_user(node->ptr, (void * __user *)ptr))"

None of this (the patch series or the original code) is mine.  My
question was more of a general one on designing ioctls, as well as
concerns with changing the existing 32-bit api.
