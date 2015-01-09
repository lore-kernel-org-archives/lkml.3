Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbbAIPzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:55:06 -0500
Received: from smtp-out-098.synserver.de ([212.40.185.98]:1047 "EHLO
	smtp-out-098.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbbAIPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:55:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9680
Message-ID: <54AFF9D3.7000007@metafoo.de>
Date: Fri, 09 Jan 2015 16:54:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: Simplify IIO provider access locking mechanism
References: <1420817893-5858-1-git-send-email-iivanov@mm-sol.com>	 <54AFF6C4.9020306@metafoo.de> <1420818639.28652.5.camel@mm-sol.com>
In-Reply-To: <1420818639.28652.5.camel@mm-sol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:50 PM, Ivan T. Ivanov wrote:
>
> On Fri, 2015-01-09 at 16:41 +0100, Lars-Peter Clausen wrote:
>> On 01/09/2015 04:38 PM, Ivan T. Ivanov wrote:
>>> Instead of checking whether provider module is still
>>> loaded on every access to device just lock module to
>>> memory when client get reference to provider device.
>>>
>>
>> This has nothing to do with the module, it's about the device. In the Linux
>> device driver model as device can be unbound at any time and the IIO
>> framework needs to handle this.
>>
>
> Hm. Probably i am missing something here, but is this
> still true if we have reference to device structure?

Yes, that only prevents the memory of device from being freed. But the 
device can still be unbound from the driver.

Think of e.g. a USB device that is pulled from the USB connector. Nothing 
you can do in software about having the device disappear.

- Lars

