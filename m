Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaDPIpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:45:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46500 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239AbaDPIpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:45:42 -0400
Date: Wed, 16 Apr 2014 10:44:53 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Chao Xie <xiechao.mail@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] fixing regressions caused by Dove in MULTI_V7
Message-ID: <20140416104453.571c8d10@skate>
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140414151236.75f8816d@skate>
	<1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Tue, 15 Apr 2014 20:15:58 +0200, Sebastian Hesselbarth wrote:

> Sebastian Hesselbarth (5):
>   ARM: iwmmxt: explicitly check for supported architectures
>   ARM: pj4: enable iWMMXt only if CONFIG_IWMMXT is set
>   ARM: pj4: properly detect existence of iWMMXt coprocessor
>   ARM: pj4: fix cpu_is_pj4 check
>   ARM: iwmmxt: allow to build iWMMXt on Marvell PJ4B

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>.

It does fix the boot on PJ4B-MP based processors that don't have iWMMXt
extensions such as the Armada XP. I've tested the following cases:

 * Armada XP (PJ4B-MP), with CONFIG_MACH_DOVE disabled and enabled
 * Armada 370 (PJ4B), with CONFIG_MACH_DOVE disabled and enabled

and all of them boot, while before your patch series, 3.15-rc1 fails to
boot on Armada XP with CONFIG_MACH_DOVE enabled.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
