Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaKCV0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:26:43 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44545 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752344AbaKCV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:26:41 -0500
Message-ID: <5457F30F.2030203@hurleysoftware.com>
Date: Mon, 03 Nov 2014 16:26:39 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] tty: serial: men_z135_uart: Fix driver for changes
 in hardware
References: <1415030753-26885-1-git-send-email-johannes.thumshirn@men.de> <5457ED0C.3090705@hurleysoftware.com>
In-Reply-To: <5457ED0C.3090705@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 04:01 PM, Peter Hurley wrote:
> On 11/03/2014 11:05 AM, Johannes Thumshirn wrote:
>> * Enable the handling of UART core's automatic flow control feature.
>>   When AFE is active disable generation of modem status IRQs.
> 
> So HUPCL doesn't work when CRTSCTS is set?

Sorry, I meant !CLOCAL. IOW,

'So !CLOCAL doesn't work when CRTSCTS is set?'

> Is this because there's actually a problem with the IP core that
> MSIs trash the autoCTS state, or is the problem that the driver
> just shouldn't be calling uart_handle_cts_change() when autoCTS is
> on?

