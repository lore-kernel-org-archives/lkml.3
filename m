Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3GFLrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 07:47:15 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38567 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3GFLrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 07:47:13 -0400
Message-ID: <51D803BC.8000403@kernel.org>
Date: Sat, 06 Jul 2013 12:47:08 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jic23@cam.ac.uk
Subject: Re: Issue with porting i2c driver to k3.10 (iio)
References: <CAGH3droX_J9JJ60EP6d62Sh6MK6T5WvYTq+uwcmJkwb0c1Yurg@mail.gmail.com> <20130704161911.GC20907@kroah.com>
In-Reply-To: <20130704161911.GC20907@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:19 PM, Greg KH wrote:
> On Thu, Jul 04, 2013 at 04:16:43PM +0300, Oleksandr Kravchenko wrote:
>> Hi All,
>>
>> I wrote i2c driver for APDS-9300 light sensor in drivers/misc, but I have some
>> questions regarding upstreaming of it.
>> 1. It works properly in kernel-3.4, but it works very slow in kernel-3.10 (on
>> mutex and i2c operations, particulary on mutex_lock() and i2c_smbus_read_data
>> ()). Does anyone know why this issue may be occurred?
> 
> What is "slow"?  Have you run 'perf' on the driver to see where it is
> spending time?
> 
>> 2. Can I send this driver without using Industrial I/O framework?
> 
> No, why would you even want to?

Looks like a fairly standard light sensor so drivers/iio/light.

Actually very close in design to some of the TAOS parts such as those supported
by the tsl2563 driver if you want a reference driver to compare with.

Jonathan
