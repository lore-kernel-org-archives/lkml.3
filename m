Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3GSVIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:08:45 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58102 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3GSVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XmxX0UQkbchU_AKJOyENcn0auBGMPzru5C4nohg_v1sQ@mail.gmail.com>
References: <1374191339-10124-1-git-send-email-mcgrof@do-not-panic.com>
 <Pine.LNX.4.44L0.1307191012330.1055-100000@iolanthe.rowland.org> <CAB=NE6XmxX0UQkbchU_AKJOyENcn0auBGMPzru5C4nohg_v1sQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 19 Jul 2013 14:08:21 -0700
X-Google-Sender-Auth: MQylXyqpdIZNBKhUmbh5Waz6hLY
Message-ID: <CAB=NE6VHgure2+2VA=XWtaii4Wc_rG7YZ=_ZetgGnvouh7HJPw@mail.gmail.com>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 2:07 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>> This is not a very good idea.  Although setting drvdata to NULL allowed
>> a lot of code to be removed, it also exposed a bunch of hidden bugs --
>> drivers were using the drvdata value even after their remove function
>> returned.
>
> Eek, have we not SmPL'ify'd a proof yet to ensure code like this no
> longer exists? Julia? :)

Come to think of it, perhaps we should require *proof* with SmPL like
this in future to avoid regressions ?

  Luis
