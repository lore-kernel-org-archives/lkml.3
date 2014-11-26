Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKZDdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:33:10 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34666 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaKZDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:33:08 -0500
Date: Tue, 25 Nov 2014 19:33:04 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rodrigo Freire <rfreire@redhat.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        linux-mtd@lists.infradead.org, Felix Fietkau <nbd@openwrt.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot time
Message-ID: <20141126033304.GR24364@ld-irv-0074>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com>
 <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com>
 <20140909170231.GA14429@logfs.org>
 <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
 <20141105202303.GN23619@ld-irv-0074>
 <9691395.7454649.1415535485079.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9691395.7454649.1415535485079.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 07:18:05AM -0500, Rodrigo Freire wrote:
> > From: "Brian Norris" <computersforpeace@gmail.com>
> > Sent: Wednesday, November 5, 2014 6:23:03 PM
> 
> > This still seems like a bad idea (using a block device + block2mtd +
> > JFFS2). Why are you doing this? See comments here:
> > http://www.linux-mtd.infradead.org/faq/jffs2.html#L_hdd_jffs2
> 
> As Felix stated on a previous message to the thread, I am using JFFS2 over
> block2mtd where regular filesystems failed to do so well. There are several
> [1] threads pointing this issue, and JFFS2 over block2mtd works like a charm
> on more harsh scenarios.
[...]
> [1] - http://bit.ly/1smGvwa

OK, so there are definitely problems with cheap SD card power cut
tolerance. That's not news. But that doesn't mean block2mtd + JFFS2 is a
good solution. In fact, when I add 'jffs2' to your Google search query
of 'raspberry pi corrupt sd card', the only mentions I see are those who
agree that this is not the right choice.

But anyway, we can look at supporting block2mtd (since you provided the
patches), even if we don't agree how it should be used. And in fact, I
might argue there are no good (production) uses for block2mtd, so I
suppose I don't have much stake in it :)

Brian
