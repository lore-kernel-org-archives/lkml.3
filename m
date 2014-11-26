Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaKZNdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:33:06 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56526 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKZNdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:33:04 -0500
Date: Wed, 26 Nov 2014 08:32:16 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        linux-mtd@lists.infradead.org, Felix Fietkau <nbd@openwrt.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Message-ID: <1754439525.4551871.1417008736061.JavaMail.zimbra@redhat.com>
In-Reply-To: <20141126033304.GR24364@ld-irv-0074>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074> <9691395.7454649.1415535485079.JavaMail.zimbra@redhat.com> <20141126033304.GR24364@ld-irv-0074>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot
 time
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: Present block2mtd timely on boot time
Thread-Index: NXoQTS7y7jHVvV045Q7gRVdqPN5CkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Brian Norris" <computersforpeace@gmail.com>
Sent: Wednesday, November 26, 2014 1:33:04 AM
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot time

> On Sun, Nov 09, 2014 at 07:18:05AM -0500, Rodrigo Freire wrote:
> > > From: "Brian Norris" <computersforpeace@gmail.com>
> > > Sent: Wednesday, November 5, 2014 6:23:03 PM
> >
> > > This still seems like a bad idea (using a block device + block2mtd +
> > > JFFS2). Why are you doing this? See comments here:
> > > http://www.linux-mtd.infradead.org/faq/jffs2.html#L_hdd_jffs2
> >
> > As Felix stated on a previous message to the thread, I am using JFFS2 over
> > block2mtd where regular filesystems failed to do so well. There are several
> > [1] threads pointing this issue, and JFFS2 over block2mtd works like a
> > charm
> > on more harsh scenarios.
> [...]
> > [1] - http://bit.ly/1smGvwa

> OK, so there are definitely problems with cheap SD card power cut
> tolerance. That's not news. But that doesn't mean block2mtd + JFFS2 is a
> good solution. In fact, when I add 'jffs2' to your Google search query
> of 'raspberry pi corrupt sd card', the only mentions I see are those who
> agree that this is not the right choice.

> But anyway, we can look at supporting block2mtd (since you provided the
> patches), even if we don't agree how it should be used. And in fact, I
> might argue there are no good (production) uses for block2mtd, so I
> suppose I don't have much stake in it :)

Hi there Brian,

This patchset primarily aims to fix a block2mtd behavior, and not introduce new features (well, the device name and a timeout option are indeed new options, but they're actually enhancements). block2mtd already exists, works nicely as boot root device on several architectures, but fails on BCM2835 arch. Our patchset only aims to get it fixed. We just want to block2mtd work on BCM2835 the way it works on different architectures. So, this is a fix.

As a side note, WRT the SD card corruption; it also happens on good quality SD cards too. The main culprit for the corruption is bad mains / power supply issues / abrupt poweroff.

Thanks for the thorough review.

Looking forward for the ACK ;-)

My best regards,

- RF.
