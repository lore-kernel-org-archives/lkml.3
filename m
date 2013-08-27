Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3H0HUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:20:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35559 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3H0HUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:20:21 -0400
Message-ID: <521C532B.7030009@ti.com>
Date: Tue, 27 Aug 2013 12:50:11 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the spi tree
References: <20130827161511.47ee5028fa50811a2adf586d@canb.auug.org.au>
In-Reply-To: <20130827161511.47ee5028fa50811a2adf586d@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tuesday 27 August 2013 11:45 AM, Stephen Rothwell wrote:
> Hi Mark,
>
> After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> In file included from drivers/spi/spi-ti-qspi.c:19:0:
> include/linux/module.h:87:32: error: '__mod_of_device_table' aliased to undefined symbol 'dra7xxx_qspi_match'
>   extern const struct gtype##_id __mod_##gtype##_table  \
>                                  ^
> include/linux/module.h:145:3: note: in expansion of macro 'MODULE_GENERIC_TABLE'
>     MODULE_GENERIC_TABLE(type##_device,name)
>     ^
> drivers/spi/spi-ti-qspi.c:458:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   MODULE_DEVICE_TABLE(of, dra7xxx_qspi_match);
>   ^
>
> Caused by commit 505a14954e2d ("spi/qspi: Add qspi flash controller").
>
> Clearly not build tested as a module. :-(
Yes, module build test was missed.  I will send a patch for this
to Mark.
> I have used the spi tree from next-20130822 for today.

