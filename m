Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaBUWyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:54:05 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:52473 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaBUWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:54:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP12Vs3LtVPOxF-Tnn4H7NjD6unXtPEOjFzRRhJhf0xndRQ@mail.gmail.com>
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
 <5307683C.50209@suse.de> <CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>
 <CAPXgP12Vs3LtVPOxF-Tnn4H7NjD6unXtPEOjFzRRhJhf0xndRQ@mail.gmail.com>
From: Ray Strode <halfline@gmail.com>
Date: Fri, 21 Feb 2014 17:53:41 -0500
Message-ID: <CAA_UwzK38FpDgv0RKfQG_QZd-OttZBQC60UffbyUGWq8E05PpQ@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
To: Kay Sievers <kay@vrfy.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 21, 2014 at 11:01 AM, Kay Sievers <kay@vrfy.org> wrote:
> Why did the tty0 change to tty1 now? That doesn't look like a "driver
> name" vs. "device name" issue?

I don't know if it's intentional, but the patch does:
+               int index = cs[i]->index;
...
+               driver = cs[i]->device(cs[i], &index);

which will presumably change the index from 0 to 1 because of this code:

static struct tty_driver *vt_console_device(struct console *c, int *index)
{
       *index = c->index ? c->index-1 : fg_console;
       return console_driver;
}

At least that's what it looks like is causing the problem from
browsing through the source a bit.

--Ray
