Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbbANQtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:49:02 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50978 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbANQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:48:59 -0500
Message-ID: <54B69DF6.7070306@suse.cz>
Date: Wed, 14 Jan 2015 17:48:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 3.14 00/77] 3.14.29-stable review
References: <20150114072224.182299947@linuxfoundation.org> <20150114163721.GA32246@roeck-us.net>
In-Reply-To: <20150114163721.GA32246@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015, 05:37 PM, Guenter Roeck wrote:
> On Tue, Jan 13, 2015 at 11:22:40PM -0800, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.14.29 release.
>> There are 77 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri Jan 16 07:22:07 UTC 2015.
>> Anything received after that time might be too late.
>>
> There are several powerpc build failures.
> 
> Building powerpc:defconfig ... failed
> Building powerpc:allmodconfig ... failed
> Building powerpc:cell_defconfig ... failed
> Building powerpc:maple_defconfig ... failed
> 
> arch/powerpc/kernel/head_64.o: In function `machine_check_handle_early':
> (.text+0x918c): undefined reference to `.power7_enter_nap_mode'

Dots from functions were removed only in commit b1576fec7f4 (powerpc: No
need to use dot symbols when branching to a function).

The backport of commit 8117ac6a6c2 (powerpc/powernv: Switch off MMU
before entering nap/sleep/rvwinkle mode) should redefine
power7_enter_nap_mode with dots IMO.

thanks,
-- 
js
suse labs
