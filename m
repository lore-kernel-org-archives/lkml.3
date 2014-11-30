Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaK3RYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:24:12 -0500
Received: from albireo.enyo.de ([46.237.207.196]:45585 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaK3RYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:24:11 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add documentation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<871tolysbb.fsf@mid.deneb.enyo.de>
	<CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com>
Date: Sun, 30 Nov 2014 18:23:53 +0100
In-Reply-To: <CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com>
	(David Herrmann's message of "Sun, 30 Nov 2014 18:15:14 +0100")
Message-ID: <87vblwtxee.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Herrmann:

> On Sun, Nov 30, 2014 at 10:02 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>> * Greg Kroah-Hartman:
>>
>>> +7.4 Receiving messages

>> What happens if this is not possible because the file descriptor limit
>> of the processes would be exceeded?  EMFILE, and the message will not
>> be received?
>
> The message is returned without installing the FDs. This is signaled
> by EMFILE, but a valid pool offset.

Oh.  This is really surprising, so it needs documentation.  But it's
probably better than the alternative (return EMFILE and leave the
message stuck, so that you receive it immediately again—this behavior
makes non-blocking accept rather difficult to use correctly).
