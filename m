Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaDZBoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 21:44:02 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:55821 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDZBn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 21:43:58 -0400
Message-ID: <535B0F5D.4020905@linaro.org>
Date: Fri, 25 Apr 2014 20:43:57 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org, devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 0/5] clk: bcm21664: add common clock support
References: <1398115587-32529-1-git-send-email-elder@linaro.org> <20140426000915.7224.11265@quantum>
In-Reply-To: <20140426000915.7224.11265@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 07:09 PM, Mike Turquette wrote:
> Quoting Alex Elder (2014-04-21 14:26:22)
>> This is series has two parts.  The first two patches are changes
>> to the existing Broadcom Kona family clock code to prepare for the
>> addition of support for another SoC, bcm21664.
>>
>> The remaining three define the binding and code for bcm21664, and
>> replace the use of "fake" clocks in the device tree with the real
>> ones.  This ends up being a fairly straightforward definition of
>> the clocks on this SoC; the rest of the clock code is shared with
>> other SoCs that use the Kona style clock system.
> 
> Hi Alex,
> 
> I'm happy to take only the clk patches or I can take the DT stuff as
> well if it gets some Acks. Let me know how you want it handled.

If all you need is an ack from Matt or Christian I'm
sure they'll provide it.  I don't care much but if
you'll take it all I can just consider it done, so
that would be my slight preference.  The DT stuff has
been out there for way past the requisite few weeks...

Thanks Mike.

					-Alex


> Regards,
> Mike
> 
>>
>> This series depends on the following patch, which has been taken
>> into the clk-fixes tree:
>>     clk: bcm281xx: don't use unnamed structs or unions
>>     https://lkml.org/lkml/2014/4/7/322
>>
>> In addition, it depends on the version 4 of the following series,
>> just (re)posted for review:
>>     clk: bcm281xx: updates
>>     https://lkml.org/lkml/2014/4/8/485
>>
>> The patches in this series--based on the current linus/master branch
>> plus the patches mentioned above--are available here:
>>     http://git.linaro.org/git/landing-teams/working/broadcom/kernel.git
>>     Branch review/bcm21664-clock-v2
>>
>> Alex Elder (5):
>>   clk: bcm281xx: move compatible string definitions
>>   ARM: dts: revise kona clock binding document
>>   ARM: dts: define clock binding for bcm21664
>>   clk: bcm21664: use common clock framework
>>   ARM: dts: use real clocks for bcm21664
>>
>>  .../devicetree/bindings/clock/bcm-kona-clock.txt   | 116 ++++++---
>>  arch/arm/boot/dts/bcm21664.dtsi                    | 190 +++++++++-----
>>  drivers/clk/bcm/Kconfig                            |   2 +-
>>  drivers/clk/bcm/Makefile                           |   1 +
>>  drivers/clk/bcm/clk-bcm21664.c                     | 290 +++++++++++++++++++++
>>  drivers/clk/bcm/clk-bcm281xx.c                     |  12 -
>>  include/dt-bindings/clock/bcm21664.h               |  62 +++++
>>  include/dt-bindings/clock/bcm281xx.h               |  12 +
>>  8 files changed, 565 insertions(+), 120 deletions(-)
>>  create mode 100644 drivers/clk/bcm/clk-bcm21664.c
>>  create mode 100644 include/dt-bindings/clock/bcm21664.h
>>
>> -- 
>> 1.9.1

