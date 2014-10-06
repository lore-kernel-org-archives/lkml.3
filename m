Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaJFJ1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:27:42 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:42913 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaJFJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
References: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
	<CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
Date: Mon, 6 Oct 2014 14:57:37 +0530
Message-ID: <CAJJ77WvDaM2MmC_r9Wop68++L0FfaRmq6oiXTp+GdqcaKKwSBw@mail.gmail.com>
Subject: Re: [PATCH] serial/core: Initialize the console pm state
From: Sudhir Sreedharan <ssreedharan@mvista.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: linux-serial@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        lkml <linux-kernel@vger.kernel.org>, olof@lixom.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Wed, Oct 1, 2014 at 10:57 PM, Kevin Hilman <khilman@kernel.org> wrote:
> On Sun, Sep 21, 2014 at 11:30 PM, Sudhir Sreedharan
> <ssreedharan@mvista.com> wrote:
>> For console devices having UART_CAP_SLEEP capability, the uart_pm_state has
>> to be initialized to UART_PM_STATE_ON. Otherwise the LCR regiser values
>> are reinitialized when uart_change_pm is called from uart_configure_port.
>>
>> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
>
> Multiple boot failures on ARM[1] were bisected down to this patch.
>
> How was this patch tested, and on which platforms?



This patch was tested on x86-64(haswell) board, which uses ST16650V2
uart(which has UART_CAP_SLEEP).
While serial driver gets initialized, console port LCR register is
getting reinitalized to 0.
Then boot logs will be seen as garbage characters.

I will re-check why this failed on the boards/archs you mentioned.

Thanks,
Sudhir
