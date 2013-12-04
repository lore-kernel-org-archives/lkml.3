Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3LDVzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:55:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56992 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3LDVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:55:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131204214325.GA19565@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
	<20131204214325.GA19565@kroah.com>
Date: Wed, 4 Dec 2013 13:55:34 -0800
X-Google-Sender-Auth: Jd0yCSnx74wPDfTBPpY1lws7lns
Message-ID: <CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, romlem@android.com,
        David Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 1:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Dec 04, 2013 at 12:46:42PM -0800, Colin Cross wrote:
>> On Wed, Dec 4, 2013 at 10:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> <snip>
>>
>> > And finally, is this all really needed?  Why not just fix the structures
>> > to be "correct", and then fix userspace to use the correct structures as
>> > well, thereby not needing a compat layer at all?
>>
>> Some of the binder ioctls take userspace pointers.  Are you suggesting
>> storing those pointers in a __u64 to avoid having to have a
>> compat_ioctl?
>
> Yes, that's the best way to solve the issue, right?

It's the least code, but in exchange you lose all the type safety and
warnings when copying in and out of the pointers, as well as sparse
checking on the __user attribute.  That doesn't seem like a good
tradeoff to me.  In addition it requires modifying the existing
heavily used 32 bit api, which means a mostly-equivalent compat layer
added in libbinder to support old kernels.

I would suggest fixing the 32-bit structures to use fixed sizes where
appropriate (__u32 instead of unsigned long) while maintaining
compatibility, and then using compat_ioctl where necessary to handle
pointers.
