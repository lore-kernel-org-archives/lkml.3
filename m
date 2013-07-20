Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3GTDgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 23:36:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:32839 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753638Ab3GTDgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 23:36:20 -0400
Date: Fri, 19 Jul 2013 23:36:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] backports: backport drvdata = NULL core driver fixes
In-Reply-To: <CAB=NE6WfbauZnzCT=jgfUtc2Roe7WfY=G7Z5OAobc9YLc0nCvw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1307192315470.24914-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Luis R. Rodriguez wrote:

> Thanks Julia. In that case I'm going to just leave this in place given
> that if there's a bug upstream we'll get it fixed as soon as a
> respective patch gets upstream as well. That is, we are not using old
> drivers, we use the same upstream drivers so if a regression was found
> in backports the fix must go upstream s well. This is one of the
> benefits of backporting -- the range of users and testers increases
> and we still benefit from the upstream bandwagon.

I don't understand.  If you're not using old drivers, and you
incorporate all the upstream patches, then what's the difference
between a backport and the current kernel?  In fact, if you're
incorporating all the upstream driver patches, then why haven't you
already got the drvdata change?

As one example of the sort of subtle problem exposed by the drvdata
change, take a look at commit b2ca69907657.

For more examples, see commits bf90ff5f3b8f, 638b9e15233c,
51ef847df746, 289b076f89c2, 53636555b919, 99a6f73c495c, 003615302a16,
94ab71ce2889, 3124d1d71d3d, c27f3efc5608, 95940a04bfe8, 5c1a0f418d8d,
db5c8b524444, 8bf769eb5f6e, 4295fe7791a1, fa919751a2d2, a9556040119a,
7bdce71822f4, and a1028f0abfb3.  Admittedly, these are all related
problems in a single subsystem, but it gives you a little idea of how 
far this goes.

Alan Stern

