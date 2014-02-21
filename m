Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaBUWSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:18:25 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:62283 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaBUWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:18:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140221202127.GA28780@kroah.com>
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com> <20140221202127.GA28780@kroah.com>
From: Ray Strode <halfline@gmail.com>
Date: Fri, 21 Feb 2014 17:18:02 -0500
Message-ID: <CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 21, 2014 at 3:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Ray, Josh, can I get some more information about this?  Is this broken
> in Linus's tree?  Or did I get the backport wrong here?
I don't think it's a problem with the backport specifically. To be
honest, i'm not even 100% sure it is that patch. It was just the only
patch that touched that code recently so it seemed likely.  I didn't
do builds to check for sure.

> What is the value of the file before and after this patch?
"tty0" in the past and "tty1" now

> And what is plymouth doing with this file value, it was incorrect
> before, what was it using the value for?
See the other (3.11) thread for my initial message, but basically
plymouth had code something like this pseudocode:

/* disable splash if there are serial consoles */
if (!contents_of_file_equals("/sys/class/tty/console/active", "tty0")) {
        disable_splash_and_force_verbose_messages();
}

since the file started saying tty1 that code started disabling the
splash for everyone in rawhide.
