Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3DYTPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:15:02 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51671 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab3DYTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:15:00 -0400
Message-ID: <517980B0.3000401@gmail.com>
Date: Thu, 25 Apr 2013 14:14:56 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mackerras <paulus@samba.org>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] ibmebus: convert of_platform_driver to platform_driver
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>  <1366596798-9457-2-git-send-email-robherring2@gmail.com>  <CAL_JsqKDF=hPEM0Jz-zZSXBCXBZ=gBjLWL6QDvq+nFWkqY3DMw@mail.gmail.com> <1366911329.2869.31.camel@pasglop>
In-Reply-To: <1366911329.2869.31.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 12:35 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-04-25 at 10:23 -0500, Rob Herring wrote:
>> Ben, Can I have your Ack for this? The change is straightforward and
>> neither of the 2 drivers used the id parameter that is removed.
> 
> Didn't you get my mail about a compile failure caused by this patch ?

No, and I can't find any evidence of a mail in my inbox or in the list
archives.

> 
> A quick build test leads to:
> 
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c: In function 'ibmebus_bus_device_probe':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:344:2: error: implicit declaration of function 'to_platform_driver' [-Werror=implicit-function-declaration]
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:344:6: error: assignment makes pointer from integer without a cast [-Werror]
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c: In function 'ibmebus_bus_device_remove':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:363:32: error: initialization makes pointer from integer without a cast [-Werror]
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c: In function 'ibmebus_bus_device_shutdown':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:373:32: error: initialization makes pointer from integer without a cast [-Werror]
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c: In function 'ibmebus_bus_legacy_suspend':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:420:32: error: initialization makes pointer from integer without a cast [-Werror]
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c: In function 'ibmebus_bus_legacy_resume':
> /home/benh/linux-powerpc-test/arch/powerpc/kernel/ibmebus.c:431:32: error: initialization makes pointer from integer without a cast [-Werror]
> cc1: all warnings being treated as errors
> make[2]: *** [arch/powerpc/kernel/ibmebus.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> 
> Haven't had a chance to look too closely today -EJETLAG :-)

You need patch 2 of this series to fix this:

driver core: move to_platform_driver to platform_device.h

which as Arnd pointed out needs to come first. I've fixed that in my
tree, but I don't think it warrants another post.

Rob
