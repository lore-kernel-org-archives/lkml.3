Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab3GPQes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:34:48 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932865Ab3GPQer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:34:47 -0400
Message-ID: <51E57620.3000907@nod.at>
Date: Tue, 16 Jul 2013 18:34:40 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [QUERY] User-Mode Linux and /dev/tty*
References: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com> <51E56DCB.3040108@nod.at> <CALkWK0kFJnDvsPy1HRzut7bxwXhLRQ0qivvy861S77Q6bhjrCQ@mail.gmail.com> <51E5705B.3070705@nod.at> <CALkWK0kibE4ZcwEPOGU2Rmt1ZfODqQ0SoN2RmhEp-BiftsF0Uw@mail.gmail.com>
In-Reply-To: <CALkWK0kibE4ZcwEPOGU2Rmt1ZfODqQ0SoN2RmhEp-BiftsF0Uw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 18:26, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> UML does not have virtual consoles.
> 
> Then why do I see this on my UML box?
> 
> # ls /dev/tty* | wc -l
> 113
> 
> Why is it creating unusable devices?  Is drivers/tty.c responsible for
> this?  What is it exactly?

This is not UML specific.
Are you using devtmpfs?

>> I'm not running HEAD, but opensuse 12.3 (with systemd) works on UML.
> 
> Also, what's with all the
> 
>    xterm_open : run_helper failed, errno = 2

2 is ENOENT.
Do you have uml-utils installed?

> messages?  (I installed xterm, but it wasn't very enlightening)
> How is drivers/xterm.c supposed to work?  And what is mconsole?

the xterm drivers opens a xterm on the host side using port-helper.
Mconsole is the management console.
Please read the documentation.

Thanks,
//richard

