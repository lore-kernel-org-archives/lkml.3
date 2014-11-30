Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaK3RPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:15:17 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43397 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaK3RPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:15:15 -0500
MIME-Version: 1.0
In-Reply-To: <871tolysbb.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<871tolysbb.fsf@mid.deneb.enyo.de>
Date: Sun, 30 Nov 2014 18:15:14 +0100
Message-ID: <CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com>
Subject: Re: kdbus: add documentation
From: David Herrmann <dh.herrmann@gmail.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Nov 30, 2014 at 10:02 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * Greg Kroah-Hartman:
>
>> +7.4 Receiving messages
>
>> +Also, if the connection allowed for file descriptor to be passed
>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
>> +returns. The receiving task is obliged to close all of them appropriately.
>
> What happens if this is not possible because the file descriptor limit
> of the processes would be exceeded?  EMFILE, and the message will not
> be received?

The message is returned without installing the FDs. This is signaled
by EMFILE, but a valid pool offset.

Thanks
David
