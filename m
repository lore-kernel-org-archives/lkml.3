Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaK3RRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:17:49 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:43266 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaK3RRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:17:47 -0500
MIME-Version: 1.0
In-Reply-To: <8761dxysl0.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<8761dxysl0.fsf@mid.deneb.enyo.de>
Date: Sun, 30 Nov 2014 18:17:46 +0100
Message-ID: <CANq1E4TEw08C1sdgVxE0faGEDg3hD+K-XH1Ra=3+0LRPhx1bgQ@mail.gmail.com>
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

On Sun, Nov 30, 2014 at 9:56 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * Greg Kroah-Hartman:
>
>> +The focus of this document is an overview of the low-level, native kernel D-Bus
>> +transport called kdbus. Kdbus exposes its functionality via files in a
>> +filesystem called 'kdbusfs'. All communication between processes takes place
>> +via ioctls on files exposed through the mount point of a kdbusfs. The default
>> +mount point of kdbusfs is /sys/fs/kdbus.
>
> Does this mean the bus does not enforce the correctness of the D-Bus
> introspection metadata?  That's really unfortunate.  Classic D-Bus
> does not do this, either, and combined with the variety of approaches
> used to implement D-Bus endpoints, it makes it really difficult to
> figure out what D-Bus services, exactly, a process provides.

kdbus operates on the transport-level only. We never touch or look at
transferred data. As such, DBus introspection data as defined by
org.freedesktop.DBus.Introspectable is not verified by the transport
layer.

Thanks
David
