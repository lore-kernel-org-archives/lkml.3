Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaDYSY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:24:29 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65323 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaDYSY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <1398447618.26477952@f179.i.mail.ru>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
	<20140425172640.GA27841@kroah.com>
	<1398447618.26477952@f179.i.mail.ru>
Date: Fri, 25 Apr 2014 14:24:23 -0400
X-Google-Sender-Auth: 786iYkwPrmm4vytycZHV4O9yQhg
Message-ID: <CAMwGMjz+=rvYBVPpkC9f1bpW46_1srmokH8-PzDS+2Z2OqCOtQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
From: Jon Ringle <jon@ringle.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 1:40 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> Fri, 25 Apr 2014 10:26:40 -0700 от Greg KH <gregkh@linuxfoundation.org>:
>> On Thu, Apr 24, 2014 at 08:56:06PM -0400, jon@ringle.org wrote:
>> > From: Jon Ringle <jringle@gridpoint.com>
>> >
>> > The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
>> > high performance UART. The SC16IS7xx's internal register set is
>> > backward-compatible with the widely used and widely popular 16C450.
>> >
>> > The SC16IS7xx also provides additional advanced features such as
>> > auto hardware and software flow control, automatic RS-485 support, and
>> > software reset.
>> >
>> > Signed-off-by: Jon Ringle <jringle@gridpoint.com>
>> > ---
>> >  drivers/tty/serial/Kconfig       |    9 +
>> >  drivers/tty/serial/Makefile      |    1 +
>> >  drivers/tty/serial/sc16is7xx.c   | 1279 ++++++++++++++++++++++++++++++++++++++
>> >  include/uapi/linux/serial_core.h |    3 +
>> >  4 files changed, 1292 insertions(+)
>> >  create mode 100644 drivers/tty/serial/sc16is7xx.c
>>
>> I get a few build warnings with this patch applied:
>>
>> drivers/tty/serial/sc16is7xx.c:1059:12: warning: ‘sc16is7xx_probe’ defined but not used [-Wunused-function]
>>  static int sc16is7xx_probe(struct device *dev,
>>             ^
>> drivers/tty/serial/sc16is7xx.c:1175:12: warning: ‘sc16is7xx_remove’ defined but not used [-Wunused-function]
>>  static int sc16is7xx_remove(struct device *dev)
>>             ^
>> drivers/tty/serial/sc16is7xx.c:1214:29: warning: ‘regcfg’ defined but not used [-Wunused-variable]
>>  static struct regmap_config regcfg = {
>>                              ^
>>
>> Can you send a follow-on patch to fix them?
>
> Seems this just should contain: "depends on I2C" in the Kconfig.

I can add "depends on I2C" in Kconfig for now, but I'm just wondering
how would this be dealt with when sometime in the future this driver
supports either I2C or SPI? Can the "depends on" be conditional
somehow?

Jon
