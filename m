Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaJPKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:15:24 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:61704 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaJPKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <7hwq80h442.fsf@deeprootsystems.com>
References: <54369F77.5000906@hurleysoftware.com>
	<1413355395-5871-1-git-send-email-ssreedharan@mvista.com>
	<7hwq80h442.fsf@deeprootsystems.com>
Date: Thu, 16 Oct 2014 15:45:20 +0530
Message-ID: <CAJJ77Wuqu1NWjQQSS+BhPB74YA+4N5zjWot_KZFWtGLUu7+RYg@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: 8250_core: restore the LCR register in set_sleep
From: Sudhir Sreedharan <ssreedharan@mvista.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: peter@hurleysoftware.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Thu, Oct 16, 2014 at 12:51 PM, Kevin Hilman <khilman@kernel.org> wrote:
> Sudhir Sreedharan <ssreedharan@mvista.com> writes:
>
>> In ST16650V2 based serial uarts, while initalizing the PM state,
>> LCR registers are being initialized to 0 in serial8250_set_sleep().
>> If console port is already initialized and being used, this will
>> throws garbage in the console.
>>
>> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
>
> Since this caused regressions in -next last time, could you describe how
> this was tested, and on what platforms?

I have tested this on arm64 board((U6_16550A)),PowerPC P5040
board(16550A)), x86-64 (haswell(ST16650V2),  Rangeley(16550A)) board.
This patch will modify only for the 8250 based serial devices.

Test Case : Booting Multiple times, suspend-resume.

Thanks,
Sudhir

>
> Thanks,
>
> Kevin
