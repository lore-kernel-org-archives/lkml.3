Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaFWOzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:55:49 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55700 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaFWOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:55:47 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A83FE7.8080904@roeck-us.net>
Date: Mon, 23 Jun 2014 07:55:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/111] 3.12.23-stable review
References: <cover.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 01:32 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.23 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jun 25 08:31:21 2014
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 136 skipped: 7 fail: 1
Failed builds:
	unicore32:defconfig
Qemu tests all passed.

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Number of builds is up to 144. I added one more build, score:defconfig, which passes.

The unicore32 build now passes in mainline. To get it to pass in 3.12,
you'd have to cherry-pick commit 1ff38c56cbd0 (arch/unicore32/mm/alignment.c:
include "asm/pgtable.h" to avoid compiling error) and backport commit fbc6c4a13bbfb
(drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap).
The video file was moved from drivers/video/fb-puv3.c after 3.12, which is why
the patch doesn't apply directly.

Guenter

