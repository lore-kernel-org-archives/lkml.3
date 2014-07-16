Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbaGPLO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:14:26 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1063 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaGPLOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:14:21 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29807
Message-ID: <53C65E8F.2080708@metafoo.de>
Date: Wed, 16 Jul 2014 13:14:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: question regarding drivers/staging/iio/adc/ad7280a.c
References: <CAB78YHwneVuVBPujeKE=rEygvtyn=VvtLtd75+pvwqxPxYcB6g@mail.gmail.com> <53C5656F.9030200@kernel.org>
In-Reply-To: <53C5656F.9030200@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 07:31 PM, Jonathan Cameron wrote:
> On 14/07/14 21:31, Himangi Saraogi wrote:
>> Hi,
>>
>> The code seems to have a memory leak. The function ad7280_attr_init
>> calls kasprintf a number of times, which calls kmalloc (or more
>> precisely kmalloc_track_caller), but this data does not ever seem to
>> be freed. I propose to introduce a devm_  version of kasprintf, which
>> will be useful for other files also. I am not very sure that will it
>> be useful to introduce a bunch of kfrees, just to remove the memory
>> leaks immediately, but I think it would be safer just to devm
>> everything, so then one is sure that everything is freed as it should
>> be, in the right order.
>>
> The question here is whether such a memory leak squashing would be
> worth applying to stable.  Personally I'd go with no. In which case
> feel free to fix it via the introduction of a devm version.

devm is probably fine here.

The long term fix should be to switch the driver to use 
iio_chan_spec_ext_info infrastructure which will handle the allocation and 
freeing internally in the IIO framework.

- Lars

