Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3CGKm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:42:26 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3CGKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:42:25 -0500
Message-ID: <51386F0D.8060105@free-electrons.com>
Date: Thu, 07 Mar 2013 11:42:21 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 3.9-rc1: hz.bc compilation breakage
References: <5137546B.2090801@free-electrons.com> <51380C65.50202@zytor.com>
In-Reply-To: <51380C65.50202@zytor.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 07/03/2013 04:41, H. Peter Anvin a écrit :
> On 03/06/2013 06:36 AM, Maxime Ripard wrote:
>> I'm compiling the kernel for an iMX28(ARM) board, and since 3.9-rc1, I
>> get the following error at compilation time:
>>
>> make[3]: *** No rule to make target
>> `/home/max/Work/2012/crystalfontz/rewrite/linux-dt/include/config/hz.h',
>> needed by `kernel/hz.bc'.  Stop.
>>
>> I'm doing a clean out-of-tree build, with the following configuration
>> file: http://code.bulix.org/m4y7se-83102?raw
>>
>> Reverting commit 1b66e0fd ("kernel: Replace timeconst.pl with a bc
>> script") make the compilation go on as usual.
>>
> 
> That file should have been created by "make *config", and I just
> verified that it does indeed do so.  That file is a sentinel for
> configuration changes; the entire build system depends on it.

I triggered this issue when switching to 3.9-rc1, and oldconfig runs at
that time, and now, running menuconfig doesn't generates it either.

> I am not sure what you mean with "clean out-of-tree", however.

make O=$(pwd) -C /path/to/linux/source some_configs
make

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
