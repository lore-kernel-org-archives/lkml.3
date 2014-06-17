Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbaFQT2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:28:08 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43771 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932657AbaFQT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:28:04 -0400
Message-ID: <53A096C2.7060800@hurleysoftware.com>
Date: Tue, 17 Jun 2014 15:28:02 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Laurent Vivier <Laurent@Vivier.EU>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Re: Broken serial port
References: <53A08D64.1060800@Vivier.EU>
In-Reply-To: <53A08D64.1060800@Vivier.EU>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 02:48 PM, Laurent Vivier wrote:
> Hi,
>
> I'm not subscribed to these mailing lists, so CC: me.
>
> I'm playing for some days with a kernel 3.15 on an old mac performa 575
> and it seems that the serial port is broken. When I log on using the
> console on the serial port it seems there is an screen refresh added
> after each character I send.

What uart driver is this happening on?

This is a known bug being worked on for these uart drivers:
sunsab
sunzilog
ip22zilog
pmac_zilog

Regards,
Peter Hurley

> A little demo :
>
> http://asciinema.org/a/10211 [at 3:20]
>
> I bisect and I found this commit :
>
> commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
> Author: Seth Bollinger <sethb@digi.com>
> Date:   Tue Mar 25 12:55:37 2014 -0500
>
>      serial_core: Fix conditional start_tx on ring buffer not empty
>
>      If the serial_core ring buffer empties just as the tty layer receives
>      an XOFF, then start_tx will never be called when the tty layer
>      receives an XON as the serial_core ring buffer is empty.  This will
>      possibly leave a few bytes trapped in the fifo for drivers that
>      disable the transmitter when flow controlled.
>
>      Signed-off-by: Seth Bollinger <sethb@digi.com>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>
> If I revert it, all works fine :
>
> http://asciinema.org/a/10212
>
> Regards,
> Laurent
>

