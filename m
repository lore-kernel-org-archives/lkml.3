Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3ETPAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:00:06 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.11]:36124 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122Ab3ETPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:00:00 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-13.tower-29.messagelabs.com!1369061997!24200169!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <519A3A5D.6090703@digi.com>
Date: Mon, 20 May 2013 16:59:41 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: mxsfb on i.MX28 uses bypassed ref_xtal 24MHz clock for LCD
References: <5196375A.1070308@digi.com> <519639A5.9070807@freescale.com>
In-Reply-To: <519639A5.9070807@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Fabio,

On 05/17/2013 04:07 PM, Fabio Estevam wrote:
> On 05/17/2013 10:57 AM, Hector Palacios wrote:
>
>> On the MX28EVK board with the Seiko 4.3" LCD, I do not see the penguin
>> or any image in v3.8 or v3.9 though the framebuffer device is present
>> and correctly loaded and backlight on.
>> This LCD works in kernel v2.6.35 with the same 24MHz frequency.
>> @Fabio, does this LCD work out of the box on v3.9? Am I missing something?
>
> Yes, works fine here.
>
> Make sure you update both the kernel and dtb files on your tests.

Agh. Now it works on the EVK. I had something wrong with the backlight (maybe a bad DTB).

Do you have any comment on the fact that the lcdif clock is bypassed to the 24MHz ref 
clock? Doesn't this make useless the definition of pixelclk for the different displays 
in mach-mxs.c?
You can only obtain whole divisors of this frequency (24, 12, 6, 4), which may not be 
accurate enough to fit some displays.

Regards,
-- 
Héctor Palacios
