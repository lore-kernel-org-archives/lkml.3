Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaFPPha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:37:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59765 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521AbaFPPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:37:26 -0400
Message-ID: <539F0F32.7080506@hurleysoftware.com>
Date: Mon, 16 Jun 2014 11:37:22 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>,
        LinusTorvaldstorvalds@linux-foundation.org
Subject: Re: Linux 3.15: SPARC serial console regression
References: <20140609205917.GA913@drone.musicnaut.iki.fi> <1402357697-20976-1-git-send-email-peter@hurleysoftware.com> <20140610192438.GA6846@ravnborg.org> <53977688.5080802@hurleysoftware.com> <20140615185635.GA22577@ravnborg.org>
In-Reply-To: <20140615185635.GA22577@ravnborg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 02:56 PM, Sam Ravnborg wrote:
> Hi Peter.
>
> On Tue, Jun 10, 2014 at 05:20:08PM -0400, Peter Hurley wrote:
>> Hi Sam,
>>
>> On 06/10/2014 03:24 PM, Sam Ravnborg wrote:
>>>> From: Peter Hurley <peter@hurleysoftware.com>
>>>> Date: Mon, 9 Jun 2014 19:21:43 -0400
>>>> Subject: [PATCH] serial: sunsab: Test for no tx data on tx restart
>>>>
>>>> Commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
>>>> 'serial_core: Fix conditional start_tx on ring buffer not empty'
>>>> exposes an incorrect assumption in sunsab's start_tx method; the
>>>> tx ring buffer can, in fact, be empty when restarting tx when
>>>> performing flow control.
>
> We have a report that commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
> ("serial_core: Fix conditional start_tx on ring buffer not empty")
> broke at least one more driver:
>
>      Aaro Koskinen <aaro.koskinen@iki.fi> reported:
>      The same problem is present also on PowerPC G5 Xserve (pmac_zilog driver)
>
> And based on code review a third driver is broken:
>
>      Sam Ravnborg <sam@ravnborg.org> reported:
>      Can you please take a look at sunzilog.c.
>      It looks like the same test is missing in sunzilog_start_tx():
>
> This is a regression so we should either revert the above commit
> or review and fix the remaining drivers.

I'm working on the audit right now, but its not entirely accurate to
call this is a regression.

All of these drivers were already broken on resume-from-suspend
and hard flow control restart.

Regards,
Peter Hurley
