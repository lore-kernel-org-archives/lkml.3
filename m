Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaGOFtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:49:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55244 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaGOFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:49:36 -0400
Message-ID: <53C4C0EA.4070401@ti.com>
Date: Tue, 15 Jul 2014 08:49:30 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: abhijit naik <abhijitnaik27@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Support for ASP DM6446 in main-line Linux Kernel
References: <CANaY3hMvw6W0+KsdCKLbXELxjv8Dka1Drvoe3AMHmD0v1oF-cw@mail.gmail.com>
In-Reply-To: <CANaY3hMvw6W0+KsdCKLbXELxjv8Dka1Drvoe3AMHmD0v1oF-cw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 06:58 PM, abhijit naik wrote:
> Hi,
> 
> I am studying ASP driver of DM6446 EVM in main line kernel 3.14. 
> I referred to both sound/soc/davinci/davinci-mcasp.c
> and sound/soc/davinci/davinci-i2s.c

For DM6446 the correct driver would be the davinci-i2s. The audio interface is
named as ASP in DM6446 which is an early version of McBSP - really basic IP
(according to the TRMs).
AFAIK there is no users of davinci-i2s in mainline and I do not have and I do
not have HW where I can test it.
Because of this lack of users there is no DT bindings for davinci-i2s - which
should be renamed as davinci-asp IMHO.
But the code looks like something which might work so at least w/o DT boot
should be trivial to enable.

If you look at arch/arm/mach-davinci/dm644x.c and board-dm644x-evm.c it is
setting up davinci-mcbsp (which is implemented within davinci-i2s driver).

So at least non DT boot should work with audio.

> Which one among the two is correct for DM6446 ASP and I am seeing that there
> is a device tree code in sound/soc/davinci/davinci-evm.c but corresponding
> support code is not present in sound/soc/davinci/davinci-mcasp.c
> 
> Please let me know whether this support is complete or can some one guide me
> to working code for DM6446 ASP

For what I see is that mainline should work with audio on dm644x-evm.

-- 
Péter
