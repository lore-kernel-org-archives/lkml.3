Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaLRQqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:46:52 -0500
Received: from smtp-out-208.synserver.de ([212.40.185.208]:1078 "EHLO
	smtp-out-208.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaLRQqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:46:51 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30521
Message-ID: <549304F4.5070105@metafoo.de>
Date: Thu, 18 Dec 2014 17:46:44 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [RFC PATCH 2/2] iio: kfifo: Add resource management devm_iio_kfifo_allocate/free
References: <1418153385-18212-1-git-send-email-k.wrona@samsung.com> <1418153385-18212-3-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1418153385-18212-3-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:29 PM, Karol Wrona wrote:
> iio kfifo allocate/free gained their devm_ wrappers.
>
> Change-Id: I10c19ccd7c01491caf088b3629137425ddccd29c
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Suggested-by: Jonathan Cameron <jic23@kernel.org>

Looks good to me.

[...]
> +struct iio_buffer *devm_iio_kfifo_allocate(struct device *dev)
> +{
> +	struct iio_buffer **ptr, *r;
> +
> +	ptr = devres_alloc(devm_iio_kfifo_release, sizeof *ptr, GFP_KERNEL);

But this should be sizeof(*ptr) to compliant with the Linux kernel coding style.

[...]
