Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3IZAHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:07:05 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53621 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825Ab3IZAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:07:03 -0400
Message-ID: <52437AA2.5040907@hurleysoftware.com>
Date: Wed, 25 Sep 2013 20:06:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.10 breaks T.tcflush (Was: tty: disassociate_ctty() sends the
 extra SIGCONT)
References: <20130915155006.GA11913@redhat.com> <20130925162125.GA18984@redhat.com>
In-Reply-To: <20130925162125.GA18984@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 12:21 PM, Oleg Nesterov wrote:
> Peter, thanks for your explanations about tty_old_pgrp/etc,
> I'll try to reply later. I need to read your email carefully.

Ok.

If you're interested, I highly recommend reading Chapter 34
("Process Groups, Sessions, and Job Control") of Michael Kerrisk's
book, The Linux Programming Interface.

> FYI, LSB tests report another failure starting from 3.10.
>
> See lsb-test-core/lts_vsx-pcts/tset/POSIX.os/devclass/tcflush/tcflush.c
> attached below. test4() fails with
>
> 	SIGTTOU not received
> 	tcflush(TCIOFLUSH) action was performed
> 	when TOSTOP was set
>
> I'll try to investigate, but let me repeat I know absolutely nothing
> about drivers/tty/, termios, etc. Perhaps you can take a look? So far I
> didn't even look into the attached code, I have no idea what it does.

Thanks for the report. I looked into this and found another regression.
Patch coming.

Looks like I'll be integrating LSB into my testbench.

Regards,
Peter Hurley

