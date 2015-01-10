Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbbAJSWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:22:15 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58789 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbAJSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:22:14 -0500
Message-ID: <54B16DD3.3030505@kernel.org>
Date: Sat, 10 Jan 2015 18:22:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Karol Wrona <k.wrona@samsung.com>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH 1/2] iio: Add no-triggered buffer helper functions
References: <1420735227-21091-1-git-send-email-k.wrona@samsung.com> <1420735227-21091-2-git-send-email-k.wrona@samsung.com> <54B108A9.7080307@metafoo.de>
In-Reply-To: <54B108A9.7080307@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/15 11:10, Lars-Peter Clausen wrote:
> On 01/08/2015 05:40 PM, Karol Wrona wrote:
>> These ones helps to create and manage iio_kfifo buffer when
>> no-triggered buffer is used.
> [...]
>> +int iio_notriggered_buffer_setup(struct iio_dev *indio_dev,
>> +                 const struct iio_buffer_setup_ops *setup_ops)
>> +
>> +{
>> +    int ret;
>> +    struct iio_buffer *buffer;
>> +
>> +    buffer = iio_kfifo_allocate();
>> +    if (!buffer)
>> +        return -ENOMEM;
>> +
>> +    iio_device_attach_buffer(indio_dev, buffer);
>> +
>> +    indio_dev->setup_ops = setup_ops;
>> +
>> +    ret = iio_buffer_register(indio_dev, indio_dev->channels,
>> +                  indio_dev->num_channels);
>> +    if (ret)
>> +        iio_kfifo_free(buffer);
>> +
> 
> We recently got rid of having to manually call iio_buffer_register() and iio_buffer_unregister(). This is now done by the IIO core. See http://git.kernel.org/cgit/linux/kernel/git/jic23/iio.git/commit/?h=togreg&id=3e1b6c95b990c93f4aa3b17e9f66221e2fa44bee
> 
> I don't think we actually need these non-triggered helper functions anymore. It basically just boils down to iio_kfifo_allocate() and iio_device_attach_buffer().
> 
Even if they are still worthwhile, I'd just put them in the core code rather
than having the additional module.  Too trivial for it to make sense
in a utility module.

I'm inclined to agree with Lars that the recent changes reduce the argument for
having these to marginal at best.  Bad luck for crossing with those!

Jonathan

J
> - Lars
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

