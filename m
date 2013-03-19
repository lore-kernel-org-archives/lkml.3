Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab3CSWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:42:32 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53411 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933877Ab3CSWma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:42:30 -0400
Message-ID: <5148E9D2.4030305@izyk.ru>
Date: Wed, 20 Mar 2013 02:42:26 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Min Zhang <mzhang@mvista.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with helper
 function
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com> <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.03.2013 0:21, Peter Hurley wrote:
> Ldisc interface functions must be called with interrupts enabled.
> Separating the ldisc calls into a helper function simplies the
> spin lock management.
> 
> Update the buffer's read index _after_ the data has been received
> by the ldisc.
> 

Hello Peter!
It looks good for me.
I think also we can remove two variables without waste:
(char_buf), (flag_buf) and use without (&buf->lock)
(head->char_buf_ptr + head->read), (head->char_buf_ptr + head->read),
because (head->read) guarded by (TTYP_FLUSHING).


I have little question about flush_to_ldisc().
Does can it be multithreaded?
I think yes, because on SMP schedule_work() can work on different CPU paralleled.

What do you think about this race condition?
https://lkml.org/lkml/2011/11/7/98

Thank you.
Ilya Zykov <linux@izyk.ru>


