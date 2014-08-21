Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaHUUXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaHUUXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:23:23 -0400
Message-ID: <53F65526.4040307@redhat.com>
Date: Thu, 21 Aug 2014 22:23:02 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: edk2-devel@lists.sourceforge.net, Michael Brown <mbrown@fensystems.co.uk>,
        linux-efi@vger.kernel.org,
        =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [edk2] Loading initrd above 4G causes freeze on boot
References: <20140809192302.GJ15082@console-pimps.org>	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>	<CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>	<20140813140219.GP15082@console-pimps.org>	<CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>	<20140813184449.GV15082@console-pimps.org>	<20140820170520.GF29733@console-pimps.org>	<CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>	<53F4FCC9.1030405@fensystems.co.uk> <20140820203011.GH29733@console-pimps.org>
In-Reply-To: <20140820203011.GH29733@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/14 22:30, Matt Fleming wrote:
> [ Pulling in EDK2 folks for help ]
> 
> On Wed, 20 Aug, at 08:53:45PM, Michael Brown wrote:
>> On 20/08/14 20:05, Mantas Mikulėnas wrote:
>>>
>>> I experimented with some things (like setting chunk size to a few kB
>>> to see if it hangs earlier or only at the very end; etc.), and finally
>>> found out that it stops freezing if I pad the initrd file to a
>>> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
>>> bytes will not.
>>>
>>> ...In other words, seems like it cannot read chunks that aren't
>>> multiples of 512 into a location above 4 GB. Or something like that...

This patch by yours truly appears remotely relevant:

https://github.com/tianocore/edk2/commit/4e39b75e

It's dated Aug 26, 2013; no idea if the firmware on Mantas' Asus K52JT,
AMI firmware v206, has it.

Thanks,
Laszlo
