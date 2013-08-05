Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3HEKEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:04:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:44442 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3HEKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:04:05 -0400
Message-ID: <51FF788B.6060804@atmel.com>
Date: Mon, 5 Aug 2013 11:03:55 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: <devel@linuxdriverproject.org>, Wu Fengguang <fengguang.wu@intel.com>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ozwpan: Fix build warning.
References: <1375638206-5916-1-git-send-email-rupesh.gujare@atmel.com> <CAJL_dMvs3-r+cKxNzG=i=TczwXwbcie0B+UbU7ykQ2K6aDu3+Q@mail.gmail.com>
In-Reply-To: <CAJL_dMvs3-r+cKxNzG=i=TczwXwbcie0B+UbU7ykQ2K6aDu3+Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/13 19:17, Anca Emanuel wrote:
> Why do not use div_u64() ?
>
> [quote]unsigned 64bit divide with 32bit divisor
>
> This is the most common 64bit divide and should be used if possible,
> as many 32bit archs can optimize this variant better than a full 64bit
> divide.
> [/quote]
>
>> -               ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
>> +               ep->credit += div64_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);

Thank you Anca.

I will resend the patch.

-- 
Regards,
Rupesh Gujare

