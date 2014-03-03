Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaCCU5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:57:51 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:47720 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaCCU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:57:50 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:d513:26c8:9faa:fc2e]
In-Reply-To: <42A09AAC7DAAF64ABE4E4C1AD5F5E295475D66E7@MEN-EX1.intra.men.de>
References: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
	<1393432147-31355-2-git-send-email-johannes.thumshirn@men.de>
	<CAOesGMjmdfRWddG+NWBg29mPik_s21fMQerCqUbEWUz8vP3KfQ@mail.gmail.com>
	<42A09AAC7DAAF64ABE4E4C1AD5F5E295475D66E7@MEN-EX1.intra.men.de>
Date: Mon, 3 Mar 2014 12:57:49 -0800
Message-ID: <CAOesGMgXwONUexeMgK0Dav=guE2rzUaegBre-55JocF-_uh7VA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus
From: Olof Johansson <olof@lixom.net>
To: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 12:09 PM, Thumshirn, Johannes Tobias
<Johannes.Thumshirn@men.de> wrote:
>
> ________________________________________
> From: Olof Johansson [olof@lixom.net]
> Sent: Monday, March 03, 2014 8:21 PM
> To: Thumshirn, Johannes Tobias
> Cc: Greg Kroah-Hartman; Jonathan Cameron; linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus
>
> On Wed, Feb 26, 2014 at 8:29 AM, Johannes Thumshirn
> <johannes.thumshirn@men.de> wrote:
>> The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
>> FPGA based devices. It is used to identify MCB based IP-Cores within
>> an FPGA and provide the necessary framework for instantiating drivers
>> for these devices.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
>> ---
>>  MAINTAINERS                     |   6 +
>>  drivers/Kconfig                 |   2 +
>>  drivers/Makefile                |   1 +
>>  drivers/mcb/Kconfig             |  15 ++
>>  drivers/mcb/Makefile            |   5 +
>>  drivers/mcb/mcb-core.c          | 414 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/mcb/mcb-internal.h      | 116 +++++++++++
>>  drivers/mcb/mcb-parse.c         | 159 +++++++++++++++
>>  include/linux/mcb.h             | 119 ++++++++++++
>>  include/linux/mod_devicetable.h |   5 +
>>  10 files changed, 842 insertions(+)
>>  create mode 100644 drivers/mcb/Kconfig
>>  create mode 100644 drivers/mcb/Makefile
>>  create mode 100644 drivers/mcb/mcb-core.c
>>  create mode 100644 drivers/mcb/mcb-internal.h
>>  create mode 100644 drivers/mcb/mcb-parse.c
>>  create mode 100644 include/linux/mcb.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 85b3dd8..5d35f6c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -5667,6 +5667,12 @@ L:       linux-watchdog@vger.kernel.org
>>  S:     Supported
>>  F:     drivers/watchdog/mena21_wdt.c
>>
>> +MEN CHAMELEON BUS (mcb)
>> +M:     Johannes Thumshirn <johannes.thumshirn@men.de>
>> +S:     Supported
>> +F:     drivers/mcb/
>> +F:     include/linux/mcb.h
>> +
>>  METAG ARCHITECTURE
>>  M:     James Hogan <james.hogan@imgtec.com>
>>  L:     linux-metag@vger.kernel.org
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index b3138fb..df2ac52 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -170,4 +170,6 @@ source "drivers/phy/Kconfig"
>>
>>  source "drivers/powercap/Kconfig"
>>
>> +source "drivers/mcb/Kconfig"
>> +
>>  endmenu
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 8e3b8b0..c5bf50c 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -155,3 +155,4 @@ obj-$(CONFIG_IPACK_BUS)             += ipack/
>>  obj-$(CONFIG_NTB)              += ntb/
>>  obj-$(CONFIG_FMC)              += fmc/
>>  obj-$(CONFIG_POWERCAP)         += powercap/
>> +obj-$(CONFIG_MCB)              += mcb/
>
> No single-driver directories like these. This needs to go somewhere else.
>
> There are two drivers in this directory, so I guess it's O.K, isn't it?

Our drivers toplevel is getting pretty crowded, so adding
vendor-specific device classes there isn't really going to work
long-term.

Final call is of course with Greg, but I'd prefer to see this under
drivers/misc or drivers/bus or similar.


-Olof
