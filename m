Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbaE2PGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:06:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55480 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaE2PG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:06:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53874CE2.2010701@roeck-us.net>
Date: Thu, 29 May 2014 08:06:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
References: <20140529043049.661315084@linuxfoundation.org>
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 09:32 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.5 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat May 31 04:30:12 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
     total: 143 pass: 133 skipped: 4 fail: 6

Qemu tests all passed.

Failing builds are

alpha:defconfig			- Fails with 'Inconsistent kallsyms data'. New failure; need to debug.
unicore32:defconfig		- still fails to build for all releases
powerpc:allmodconfig	 	- fail for binutils 2.3 and 2.4. known problem; patch pending
powerpc:ppc64e_defconfig	- fail if built with binutils 2.4; patch pending
powerpc:chroma_defconfig	- fail if built with binutils 2.4; patch pending

Bisect points to commit 'vlan: Fix lockdep warning with stacked vlan devices' as culprit
for the alpha:defconfig build failure. Reverting this patch fixes the problem.
I looked at the patch, but I have no idea what may cause the failure.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

