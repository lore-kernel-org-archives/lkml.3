Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3JWV5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:57:08 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:38816 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3JWV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 17:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <87r4bcdok1.fsf@redhat.com>
References: <87r4bcdok1.fsf@redhat.com>
Date: Wed, 23 Oct 2013 14:57:02 -0700
Message-ID: <CA+8MBb+0wruR-T8Rkk_WQ6Try4ct2ZCm8o=js4eO8s7cogcs+g@mail.gmail.com>
Subject: Re: [PATCH] pstore: avoid incorrectly mark entry as duplicate
From: Tony Luck <tony.luck@gmail.com>
To: Madper Xie <cxie@redhat.com>
Cc: Anton Vorontsov <anton@enomsg.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        =?UTF-8?B?5oiQ6aqPIOiwog==?= <bbboson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 7:55 AM, Madper Xie <cxie@redhat.com> wrote:
> The "duplicate" entries won't appear in pstorefs. And a complain will be
> print -- pstore: failed to load 76 record(s) from 'efi'

Maybe I don't quite get this - but it sounds like you have a whole lot
of entries using up space in efivars that have similar names - differing
just in the timestamp - that won't show up in the pstore filesystem - because
we'd try to name them all the same thing.

How did all those things end up in efivars?

Wouldn't the right fix be to make pstore allow them all to appear (using the
timestamp to differentiate names?) so that we could see them, log them,
and then remove them from pstore (in turn freeing up efivars space - which
people keep telling me is in short supply).

-Tony
