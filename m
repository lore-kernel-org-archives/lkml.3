Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3GSVmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:42:03 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38872 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3GSVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307192326080.2229@localhost6.localdomain6>
References: <1374191339-10124-1-git-send-email-mcgrof@do-not-panic.com>
 <Pine.LNX.4.44L0.1307191012330.1055-100000@iolanthe.rowland.org>
 <CAB=NE6XmxX0UQkbchU_AKJOyENcn0auBGMPzru5C4nohg_v1sQ@mail.gmail.com>
 <CAB=NE6VHgure2+2VA=XWtaii4Wc_rG7YZ=_ZetgGnvouh7HJPw@mail.gmail.com> <alpine.DEB.2.02.1307192326080.2229@localhost6.localdomain6>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 19 Jul 2013 14:41:37 -0700
X-Google-Sender-Auth: TRBG-eF4GOReapYaUZlcX5O-3aw
Message-ID: <CAB=NE6WfbauZnzCT=jgfUtc2Roe7WfY=G7Z5OAobc9YLc0nCvw@mail.gmail.com>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 2:27 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Fri, 19 Jul 2013, Luis R. Rodriguez wrote:
>
>> On Fri, Jul 19, 2013 at 2:07 PM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> >> This is not a very good idea.  Although setting drvdata to NULL allowed
>> >> a lot of code to be removed, it also exposed a bunch of hidden bugs --
>> >> drivers were using the drvdata value even after their remove function
>> >> returned.
>> >
>> > Eek, have we not SmPL'ify'd a proof yet to ensure code like this no
>> > longer exists? Julia? :)
>>
>> Come to think of it, perhaps we should require *proof* with SmPL like
>> this in future to avoid regressions ?
>
> Is it a concurrency problem?  SmPL is not so good at that in the general
> case.  One would have to know a specific case where other functions of the
> driver can be invoked after remove.

Thanks Julia. In that case I'm going to just leave this in place given
that if there's a bug upstream we'll get it fixed as soon as a
respective patch gets upstream as well. That is, we are not using old
drivers, we use the same upstream drivers so if a regression was found
in backports the fix must go upstream s well. This is one of the
benefits of backporting -- the range of users and testers increases
and we still benefit from the upstream bandwagon.

  Luis
