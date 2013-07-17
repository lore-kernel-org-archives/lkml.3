Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3GQKFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:05:45 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:56772 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3GQKFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:05:43 -0400
Date: Wed, 17 Jul 2013 13:05:39 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: my first post
Message-ID: <20130717130539.557c4f62@mdontu-l>
In-Reply-To: <000d01ce82b4$2d9c1150$88d433f0$@com>
References: <000d01ce82b4$2d9c1150$88d433f0$@com>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 14:09:20 +0800 merrysoft@tom.com wrote:
> I have meeted a problem with linux kernel 2.6.X.X that my user app
> wants to get thread kernel stack frame ponter(FP) from user space by
> system call or /proc system or any other ways except driver. I do not
> want to write a driver,) to finish it. I have endured this problem
> for a long time.
> 
> would anyone please to give me a hint to solve the problem.
> 

(I'm ignoring the questionable practicality of this)

People have gone to great lengths not to reveal sensitive addresses
from ring 0, %rsp/%rbp being subject to this restriction. If you
configure your kernel to expose full /dev/mem (CONFIG_STRICT_DEVMEM=n),
then using the image for your running kernel and with a bit of DWARF
knowledge, I _think_ it's possible to list the current running threads
and their contexts (ie. CPU registers). Otherwise, I don't believe
there's any way you can achieve this, other than exploiting a bug. :-)

-- 
Mihai Donțu
