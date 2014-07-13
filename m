Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaGMNa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 09:30:57 -0400
Received: from smtp-out-210.synserver.de ([212.40.185.210]:1104 "EHLO
	smtp-out-210.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaGMNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 09:30:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 3329
Message-ID: <53C288F0.3070001@metafoo.de>
Date: Sun, 13 Jul 2014 15:26:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kys@microsoft.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        teg@jklm.no, Mischa.Jonker@synopsys.com, msalter@redhat.com,
        knaack.h@gmx.de, rdunlap@infradead.org, linux-input@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C1F7DE.3060102@gmail.com>	<201407130545.23004.marex@denx.de> <CAF0htA60juBVkPo2HQKMDGcEr-wRzRVL_6JgHAa+7WVE_E8M0Q@mail.gmail.com> <53C25551.1050909@nod.at>
In-Reply-To: <53C25551.1050909@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 11:45 AM, Richard Weinberger wrote:
> Am 13.07.2014 11:27, schrieb Lennox Wu:
>> As I said before, some configurations don't make sense.
>
> If such a configuration can be achieved using allmod/yesconfig it has to be fixed.
> Chen's fixes seem reasonable as not all architectures support iomem.

Maybe we should stub out ioremap() and friends when COMPILE_TEST is enabled to 
avoid these linker errors. That's in my opinion better than turning most of the 
'depends on COMPILE_TEST' into 'depends on COMPILE_TEST && HAS_IOMEM'. The 
issue comes up quite a lot and it is often overlooked when adding a driver that 
can be build when COMPILE_TEST is enabled.

- Lars

