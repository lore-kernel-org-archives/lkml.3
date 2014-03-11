Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaCKPfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:35:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33803 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaCKPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <531EF864.5020104@hurleysoftware.com>
References: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>
	<CAMuHMdVwpQEWAVHA5BO2xXzaNc1DTdteDMWFHQ=MFJoo4Afm_A@mail.gmail.com>
	<531E7F81.20400@hurleysoftware.com>
	<CAMuHMdUeUjuBe0tWpYBZqwqWT=euPAn6fwzmXMYCP573Q1BDXQ@mail.gmail.com>
	<531EF864.5020104@hurleysoftware.com>
Date: Tue, 11 Mar 2014 16:35:38 +0100
X-Google-Sender-Auth: t74vl8r2Xb4FVaNxt01ITm-nacU
Message-ID: <CAMuHMdVgg-AbhiRPFJt=nXpP6chPw7L+ZMu8a3rnC61gaSZ41A@mail.gmail.com>
Subject: Re: serial core: crash / race condition on unbind
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Mar 11, 2014 at 12:49 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 03/11/2014 06:58 AM, Geert Uytterhoeven wrote:
>> On Tue, Mar 11, 2014 at 4:14 AM, Peter Hurley <peter@hurleysoftware.com>
>> wrote:
>>>>
>>>>
>>>>           [...]
>>>>
>>>>           /*
>>>>            * Indicate that there isn't a port here anymore.
>>>>            */
>>>>           uport->type = PORT_UNKNOWN;
>>>>
>>>>           state->uart_port = NULL;
>>>
>>>
>>> How did this ever work?
>>>
>>> Detaching the ll driver from the tty port in this manner is not ok;
>>> as you already note, it blows up if consoles are still running.
>>
>> No one unbinds serial drivers using serial_core, as all these drivers are
>> for fixed hardware?
>
> Yep, never tested until now :)
> Do you need this to work?

Well, "need" may be a bit strong. Crashes are not so nice.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
