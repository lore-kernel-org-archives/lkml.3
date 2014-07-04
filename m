Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaGDHGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:06:36 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:37670 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGDHGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:06:23 -0400
Message-ID: <53B65255.9000303@synopsys.com>
Date: Fri, 4 Jul 2014 12:35:57 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH v2 REBASED 00/10] Generic earlyconsole for ARC UART Driver
References: <1403598315-1429-1-git-send-email-vgupta@synopsys.com> <CAL_JsqJF-a3K+dUHpwgSLNrwZTHLp2uj44bZaNboVpTtc8a-RA@mail.gmail.com>
In-Reply-To: <CAL_JsqJF-a3K+dUHpwgSLNrwZTHLp2uj44bZaNboVpTtc8a-RA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 25 June 2014 02:35 AM, Rob Herring wrote:
> On Tue, Jun 24, 2014 at 3:25 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> Hi,
>>
>> This is slightly modified repost of series posted last week
>> http://www.spinics.net/lists/linux-serial/msg12884.html
>>
>> This series switches ARC UART from custom earlyprintk support to generic
>> earlycon (many thanks to Rob for doing that). And also build on Grant's recent
>> work for using DT stdout-path as default console.
>>
>> The motivation is to get rid of the early platform code, which in turn
>> would help consolidate the init code across several ARC platforms.
>>
>> First 3 patches are general cleanup/refactoring, not necesarily related to
>> earlycon.
> 
> Other than my comment on patch 6:
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Is something else needed for this to me merged in tty-next for 3.17.
I've had only 1 minor comment from Rob, and my reply to him never reached completion.

Thx,
-Vineet

> 
>>
>> v2 <- v1
>> --------
>> * Rebased on linux-next: 20140623
>> * Patch 9 split into 9 and 10 for driver/platform changes
>> * Patch 10 also uses the DT stdout-path so no need for console=
>>
>>
>> Thx,
>> -Vineet
>>
>>
>> Vineet Gupta (10):
>>   serial/arc: use uart_console_write() helper
>>   serial/arc: Refactor by referencing to uart_port where possible
>>   serial/arc: Remove the workaround for legacy ISS
>>   serial/arc: Use generic earlycon infrastructure
>>   serial/arc: remove earlyprintk support and switch to earlycon
>>   serial/arc: remove last remanants of platform data
>>   serial/arc: inline the probe helper
>>   ARC: [arcfpga] RIP early uart platform device stuff
>>   serial/arc: Enable DT based earlycon
>>   ARC: [arcfpga] stdout-path now suffices for earlycon/console
>>
>>  arch/arc/boot/dts/angel4.dts     |   3 +-
>>  arch/arc/plat-arcfpga/Kconfig    |   7 -
>>  arch/arc/plat-arcfpga/platform.c |  97 +-----------
>>  drivers/tty/serial/Kconfig       |   1 +
>>  drivers/tty/serial/arc_uart.c    | 329 ++++++++++++++-------------------------
>>  5 files changed, 123 insertions(+), 314 deletions(-)
>>
>> --
>> 1.8.3.2
>>
> 
> 

