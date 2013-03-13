Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab3CMSBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:01:07 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35840 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CMSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <1363150138-20819-1-git-send-email-ch.naveen@samsung.com>
References: <1362625743-10401-1-git-send-email-ch.naveen@samsung.com>
	<1363150138-20819-1-git-send-email-ch.naveen@samsung.com>
Date: Wed, 13 Mar 2013 11:01:03 -0700
X-Google-Sender-Auth: 6LTjcU8YNICZvvQmK7fYM3uLMgM
Message-ID: <CAD=FV=XoE6NCruDUv2UajaP+LWDCp+pgaZJsEKpkoxy3tZNeAw@mail.gmail.com>
Subject: Re: [PATCH v3] iio: adc: exynos5_adc: fix compilation warnings
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio <linux-iio@vger.kernel.org>, dan.carpenter@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Tue, Mar 12, 2013 at 9:48 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> Doug, There was a comment from Lars regarding the match not
> being NULL, if driver depends on CONFIG_OF. So, i've removed
> the NULL check in v2 of this patch.
>         https://patchwork.kernel.org/patch/2222841/
>
> I'm checking the return value of get_version() for -ve values before
> assigning to info->version. So, i left the (unsigned int) unchanged.

Hmmm, I guess this was the point that confused me.  I went back and
agree with Lars--it can't be NULL.  ...but that means that
exynos_adc_get_version() can't return an error, so why are we checking
for an error?

-Doug
