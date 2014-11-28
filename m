Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaK1VAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:00:09 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56276 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaK1VAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:00:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Nov 2014 22:02:01 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
In-Reply-To: <34359137.rt8QrS7shW@wuerfel>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch>
 <1417193015-6033-3-git-send-email-stefan@agner.ch>
 <34359137.rt8QrS7shW@wuerfel>
Message-ID: <7cd7c820d32cb04fa1d59889d16666a9@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Nov 28 21:59:36 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5478e23812811146999769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-28 17:49, Arnd Bergmann wrote:
> On Friday 28 November 2014 17:43:35 Stefan Agner wrote:
>> Support Vybrid SoC's system reset controller (SRC). Currently we
>> don't register a reset controller but only support the imx_cpu_jump
>> and imx_cpu_arg functions.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> I think this should be a platform driver in drivers/power/reset.

Yeah, I thought that too, see my cover letter. The problem is, in that
module are also some register which are of interest when implementing
suspend/resume support (see cover letter too). However, we could also
just make a dt entry for that reset register only, and create another dt
entry for the other registers.

> If the SRC is also capable of resetting individual blocks instead of just
> the entire machine, it would be a reset driver in drivers/reset instead.

Beside the system reset, there is only a mask functionality for the
watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
M4). This makes the SRC module in the Vybrid a bit different then what
is available on other i.MX SoC's...

--
Stefan

> 
> 	Arnd

