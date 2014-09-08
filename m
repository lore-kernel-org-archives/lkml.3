Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaIHXqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:46:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50102 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbaIHXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:46:21 -0400
Message-ID: <540E3FC6.2010503@hurleysoftware.com>
Date: Mon, 08 Sep 2014 19:46:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] tty/serial flow control fixes
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <20140908232445.GA28204@kroah.com> <540E3CDF.8020607@hurleysoftware.com> <20140908234324.GA14132@kroah.com>
In-Reply-To: <20140908234324.GA14132@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 07:43 PM, Greg Kroah-Hartman wrote:
> On Mon, Sep 08, 2014 at 07:33:51PM -0400, Peter Hurley wrote:
>> On 09/08/2014 07:24 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Sep 02, 2014 at 05:39:09PM -0400, Peter Hurley wrote:
>>>> Hi Greg,
>>>>
>>>> This patch series reworks the internals of tty and serial flow control to
>>>> fix multiple races in both START/STOP flow control and RTS/CTS flow control.
>>>>
>>>> The main changes in this series are:
>>>> Patch 1
>>>>    Backs out the UPF_HARD_FLOW kludge for 8250. This revert should be
>>>>    for mainline and -next
>>>>
>>>> Patches 3-7
>>>>    Fixes to x_char handling (ie., sending START/STOP) both in the serial
>>>>    core and to several UART drivers
>>>>
>>>> Patches 10-15
>>>>    Rename and move ASYNC_CTS_FLOW and ASYNC_CHECK_CD statuses into
>>>>    a private field for the serial core, and add helper functions to test
>>>>    those statuses for UART drivers.
>>>>
>>>>    This is a necessary step toward making tty port->flags SMP-safe, without
>>>>    introducing a new lock.
>>>
>>> I stopped applying at patch 13, due to the objections to that patch.
>>> Please redo the rest of the series and resend.
>>
>> I'm going to wait for the fallout from patch 21 to shake out first.
> 
> Why, the earlier patches in this series should be ok to go, right?  They
> don't depend on 21 to be "correct".

Oh, you want me to redo just 14 through 20, and resend that?

Regards,
Peter Hurley

