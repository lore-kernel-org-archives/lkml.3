Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaCKLuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:50:05 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38798 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536AbaCKLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:50:01 -0400
Message-ID: <531EF864.5020104@hurleysoftware.com>
Date: Tue, 11 Mar 2014 07:49:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: serial core: crash / race condition on unbind
References: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>	<CAMuHMdVwpQEWAVHA5BO2xXzaNc1DTdteDMWFHQ=MFJoo4Afm_A@mail.gmail.com>	<531E7F81.20400@hurleysoftware.com> <CAMuHMdUeUjuBe0tWpYBZqwqWT=euPAn6fwzmXMYCP573Q1BDXQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUeUjuBe0tWpYBZqwqWT=euPAn6fwzmXMYCP573Q1BDXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 06:58 AM, Geert Uytterhoeven wrote:
> Hi Peter,
>
> On Tue, Mar 11, 2014 at 4:14 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>>
>>>           [...]
>>>
>>>           /*
>>>            * Indicate that there isn't a port here anymore.
>>>            */
>>>           uport->type = PORT_UNKNOWN;
>>>
>>>           state->uart_port = NULL;
>>
>> How did this ever work?
>>
>> Detaching the ll driver from the tty port in this manner is not ok;
>> as you already note, it blows up if consoles are still running.
>
> No one unbinds serial drivers using serial_core, as all these drivers are
> for fixed hardware?

Yep, never tested until now :)
Do you need this to work?

> Hot-pluggable usb-serial doesn't use serial_core.

I guess none of the 8250 PCI adapters are hot-pluggable...

Regards,
Peter Hurley



