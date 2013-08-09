Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449Ab3HIG5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:57:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58252 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab3HIG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:57:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520492F3.1050806@roeck-us.net>
Date: Thu, 08 Aug 2013 23:57:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
References: <20130809015010.208118575@linuxfoundation.org>
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 06:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.6 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> and the diffstat can be found below.
>

Cross build results:
	Total builds: 69 Total build errors: 2

Details:
	http://server.roeck-us.net:8010/builders/stable-queue-3.10/builds/47/steps/shell/logs/stdio/text

Same results as before, except that I dropped a couple of builds and added some others.

The failing builds are arm:allmodconfig and mips:allmodconfig.
For both, the errors don't exist in mainline and should be trivial to fix in case anyone is interested.

arm:
	FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'

[This one has been fixed upstream with commit 22e8099f4f6621b8d165e238cdef2a1cf655e159. Might be worthwhile
  adding it to -stable]

mips:
	drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of function 'pci_iomap'
	drivers/net/ethernet/3com/3c59x.c:1044:3: error: implicit declaration of function 'pci_iounmap'

[no idea why this works upstream]

Guenter

