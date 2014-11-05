Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKETiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:38:18 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:34362 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaKETiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:38:14 -0500
MIME-Version: 1.0
In-Reply-To: <1412864192.28467.72.camel@acox1-desk.ger.corp.intel.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
 <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com>
 <1412799101.28467.68.camel@acox1-desk.ger.corp.intel.com> <CAPybu_3b6epYcQ1c0L0E1so7BNJ7DndA4E2nHDfj8OYjR3u0Zw@mail.gmail.com>
 <1412864192.28467.72.camel@acox1-desk.ger.corp.intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 5 Nov 2014 20:37:53 +0100
Message-ID: <CAPybu_1wg5wSmJxofC1oGVr-w8OEVFChcoHRSSq5RpFGDKE69g@mail.gmail.com>
Subject: Re: [PATCH 03/12] serial_core: Handle TIOC[GS]RS485 ioctls.
To: Alan Cox <alan@linux.intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

After almost one month with no other comments I am planning to resend
the patchset including the lock patch. May I add your Reviewed or
Acked by to any of the patches?

Thanks :)

On Thu, Oct 9, 2014 at 4:16 PM, Alan Cox <alan@linux.intel.com> wrote:
> On Thu, 2014-10-09 at 10:07 +0200, Ricardo Ribalda Delgado wrote:
>> Hello Alan
>>
>> >
>> > What is the locking between setting/getting/driver use of the config ?
>> > This really needs a lock (termios sem I think is perhaps appropriate
>> > given when the values are normally referenced).
>>
>> I tried implementing it with the sermios sem
>> ((&(uart_port)->state->port.tty->termios_rwsem)), but some drivers
>> access the rs485 structure inside their irq handler. So I have see
>> options here
>>
>> 1) Protect the structure with uart_port->lock spinlock
>> 2) Assume that an assignment is atomic on critical sections where I
>> cannot hold the rwsem.
>>
>> I think 1) is more correct. Any issues that I continue in this
>> direction? Any better idea?
>
> For uart #1 sounds right to me too.
>
> Alan
>
>



-- 
Ricardo Ribalda
