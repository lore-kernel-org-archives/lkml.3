Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaCSWCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:02:43 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34736 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCSWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:02:41 -0400
Message-ID: <532A143D.9070108@kernel.org>
Date: Wed, 19 Mar 2014 22:03:41 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alec Berg <alecaberg@google.com>
CC: Alec Berg <alecaberg@chromium.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        olof@lixom.net
Subject: Re: [PATCH] iio: querying buffer scan_mask should return 0/1
References: <1395255044-20173-1-git-send-email-alecaberg@chromium.org> <77ce5285-713f-4f2e-97b0-702c93404d82@email.android.com> <CAGgO2Lgka8-S70ydrNRErwUPYNmTXvpNk-k6ApFNpqjGRVjH4Q@mail.gmail.com>
In-Reply-To: <CAGgO2Lgka8-S70ydrNRErwUPYNmTXvpNk-k6ApFNpqjGRVjH4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, an obscure platform used by hardly anyone ;)

Oops.

Given timing this will be post the merge window, but I'll mark it for stable.

On 19/03/14 21:33, Alec Berg wrote:
> I'm using x86, not sure what other architectures, if any, that it affects.
>
> Thanks.
>
>
> On Wed, Mar 19, 2014 at 1:31 PM, Jonathan Cameron <jic23@kernel.org <mailto:jic23@kernel.org>> wrote:
>
>
>
>     On March 19, 2014 6:50:44 PM GMT+00:00, Alec Berg <alecaberg@chromium.org <mailto:alecaberg@chromium.org>> wrote:
>      >Ensure that querying the IIO buffer scan_mask returns a value of
>      >0 or 1. Currently querying the scan mask has the value returned
>      >by test_bit(), which returns either true or false. For some
>      >architectures test_bit() may return -1 for true, which will appear
>      >to return an error when returning from iio_scan_mask_query().
>     I'm curious now.  Which architectures?  Change is fine BTW. Will pick when I get a few mins...
>      >
>      >Additionally, it's important for the sysfs interface to consistently
>      >return the same thing when querying the scan_mask.
>      >
>      >Signed-off-by: Alec Berg <alecaberg@chromium.org <mailto:alecaberg@chromium.org>>
>      >---
>      > drivers/iio/industrialio-buffer.c | 6 ++++--
>      > 1 file changed, 4 insertions(+), 2 deletions(-)
>      >
>      >diff --git a/drivers/iio/industrialio-buffer.c
>      >b/drivers/iio/industrialio-buffer.c
>      >index c67d83b..fe25042 100644
>      >--- a/drivers/iio/industrialio-buffer.c
>      >+++ b/drivers/iio/industrialio-buffer.c
>      >@@ -165,7 +165,8 @@ static ssize_t iio_scan_el_show(struct device *dev,
>      >       int ret;
>      >       struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>      >
>      >-      ret = test_bit(to_iio_dev_attr(attr)->address,
>      >+      /* Ensure ret is 0 or 1. */
>      >+      ret = !!test_bit(to_iio_dev_attr(attr)->address,
>      >                      indio_dev->buffer->scan_mask);
>      >
>      >       return sprintf(buf, "%d\n", ret);
>      >@@ -866,7 +867,8 @@ int iio_scan_mask_query(struct iio_dev *indio_dev,
>      >       if (!buffer->scan_mask)
>      >               return 0;
>      >
>      >-      return test_bit(bit, buffer->scan_mask);
>      >+      /* Ensure return value is 0 or 1. */
>      >+      return !!test_bit(bit, buffer->scan_mask);
>      > };
>      > EXPORT_SYMBOL_GPL(iio_scan_mask_query);
>      >
>
>     --
>     Sent from my Android phone with K-9 Mail. Please excuse my brevity.
>
>

