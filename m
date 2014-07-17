Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbaGQPcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:32:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58277 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933006AbaGQPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:32:09 -0400
Message-ID: <53C7EC6F.6060902@hurleysoftware.com>
Date: Thu, 17 Jul 2014 11:31:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: balbi@ti.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-5-git-send-email-bigeasy@linutronix.de> <20140716151604.GG1365@saruman.home> <53C6A050.2050409@linutronix.de> <20140716160614.GI1365@saruman.home>
In-Reply-To: <20140716160614.GI1365@saruman.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 12:06 PM, Felipe Balbi wrote:
> On Wed, Jul 16, 2014 at 05:54:56PM +0200, Sebastian Andrzej Siewior wrote:
>> On 07/16/2014 05:16 PM, Felipe Balbi wrote:

>>> I wonder if you should get_sync() on start_tx() and only
>>> put_autosuspend() at stop_tx(). I guess the outcome would be
>>> largely the same, no ?
>>
>> I just opened minicom on ttyS0 and gave a try. start_tx() was invoked
>> each time I pressed a key (sent a character). I haven't seen stop_tx()
>> even after after I closed minicom. I guess stop_tx() is invoked if you
>> switch half-duplex communication.
>
> that's bad, I expected stop to be called also after each character.

The 8250 core auto-stops tx when the tx ring buffer is empty (except
in the case of dma, where stopping tx isn't necessary).

Regards,
Peter Hurley
