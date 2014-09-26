Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaIZC6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:58:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22458 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaIZC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:58:14 -0400
Message-ID: <5424D632.4000004@hisilicon.com>
Date: Fri, 26 Sep 2014 10:57:54 +0800
From: Wei Xu <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
References: <20140926115539.6873630b@canb.auug.org.au>
In-Reply-To: <20140926115539.6873630b@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/26 9:55, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the arm-soc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> Error: arch/arm/boot/dts/hisi-x5hd2.dtsi:374.22-23 syntax error
> FATAL ERROR: Unable to parse input tree
> 
> There are a series of new commits to this file today and I have no idea
> which one caused the problem.

Hi Stephen,

Sorry for that.
It is caused by this commit: 610bd8722ef4 "ARM: dts: hix5hd2: add wdg node".
And Olof has already helped to reverted this commit.

Best Regards,
Wei

> I reverted:
> 
> 610bd8722ef4	"ARM: dts: hix5hd2: add wdg node"
> 6868feb6dd97	"ARM: dts: hix5hd2: add gpio node"
> 420a2d55f046	"ARM: dts: hix5hd2: add sata node"
> f16c7fb2f3ff	"ARM: dts: hix5hd2: add usb node"
> b196e1ca400d	"ARM: dts: hix5hd2: add mmc node"
> de8b6054780e	"ARM: dts: hix5hd2: add gmac node"
> 
> which fixed the build problem.
> 

