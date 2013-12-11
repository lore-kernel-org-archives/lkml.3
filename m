Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3LKSKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:10:18 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54797 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKSKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:10:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAMP5XgeGRjK5rPeMFv-LT3u+Bvc8WumtDgMdgnYDXO0t_C__Cw@mail.gmail.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
	<20131204214325.GA19565@kroah.com>
	<CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
	<20131204220247.GA22031@kroah.com>
	<CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
	<CAMoF9u1W4-xUFjtMw+SuwR=wgnpfq4uMucKciqrqp81WK1aNmw@mail.gmail.com>
	<CAMP5XgeGRjK5rPeMFv-LT3u+Bvc8WumtDgMdgnYDXO0t_C__Cw@mail.gmail.com>
Date: Wed, 11 Dec 2013 20:10:08 +0200
Message-ID: <CAMoF9u2GN0GuD9azO3irU80tY+bnRhBFxUw3fhajEkFYH9ugmg@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Octavian Purdila <octavian.purdila@intel.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>,
        Rom Lemarchand <romlem@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 5:21 AM, Arve Hjønnevåg <arve@android.com> wrote:
>
> Assuming you are talking about a kernel compat layer that translates
> the flat_binder_object structs as they pass between 32 bit and 64 bit
> processes, that will not always work. The data portion of the message
> sometimes contain size values that are invisible to the kernel, but
> these values will be wrong if the kernel move data to make room for a
> different size flat_binder_object.
>

Hi Arve,

Yes, I was talking about translating flat_binder_objects.

I understand the potential issue for the user data payload, however,
since most applications will use libbinder, the only problematic case
is readIntPtr/writeIntPtr, which we can deprecate and convert
applications that use it to readInt64. AFAICS there is only one user
in the AOSP for this API (libmedia).

If you are referring to data blobs that application parses I don't
think there is anything we can do, even at libbinder level.

Can you give me an example of the sort of problems you see?

Thanks,
Tavi
