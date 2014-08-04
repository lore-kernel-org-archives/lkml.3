Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaHDK6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:58:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59940 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaHDK6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:58:02 -0400
Message-ID: <53DF6733.1040604@mev.co.uk>
Date: Mon, 4 Aug 2014 11:57:55 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy stuff
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8825F33D7B@P3PWEX4MB002.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F33D7B@P3PWEX4MB002.ex4.secureserver.net>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-31 21:28, Hartley Sweeten wrote:
> On Thursday, July 31, 2014 6:48 AM, Ian Abbott wrote:
>> The "amplc_pci224" driver retains a "legacy" attach mechanism via the
>> `COMEDI_DEVCONFIG` ioctl and the comedi driver "attach" hook, but
>> usually attaches PCI devices automatically via the comedi driver's
>> "auto_attach" hook.  The legacy mechanism is only retained so that
>> options can be passed via the ioctl to indicate how some hardware
>> jumpers are set on the boards, which is used to set up the range tables.
>> That's no use if the PCI device is attached automatically as the range
>> tables will be set up according to the factory default jumper positions.
>>
>> Change the range tables to include all possible ranges, regardless of
>> jumper positions.  Then there is no need to have options to control
>> setting up the range tables and the "legacy" attach mechanism can be
>> removed.
>>
>> Also, tidy the code up a bit.
>
> Looks good.
>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Side note:
>
> Now that the manual attach has been removed, you could also remove
> the board information from the comedi_driver declaration.

Good point.  I can do that as a follow-up patch.  It only affects the 
output of /proc/comedi I think.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
