Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3CRSNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:13:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59172 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479Ab3CRSNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:13:45 -0400
Message-ID: <1363630416.2074.25.camel@joe-AO722>
Subject: Re: [PATCH] bluetooth: use PTR_RET instead of IS_ERR + PTR_ERR
From: Joe Perches <joe@perches.com>
To: Silviu Popescu <silviupopescu1990@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 11:13:36 -0700
In-Reply-To: <CAPWTe+JzznuWYKksAfxkD=u9kv8DuAF4v2AWVxd2OUeDtCYKBA@mail.gmail.com>
References: <1363111995-26866-1-git-send-email-silviupopescu1990@gmail.com>
	 <20130313.053145.2200448840921851390.davem@davemloft.net>
	 <CAPWTe+JzznuWYKksAfxkD=u9kv8DuAF4v2AWVxd2OUeDtCYKBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 20:05 +0200, Silviu Popescu wrote:
> On Wed, Mar 13, 2013 at 11:31 AM, David Miller <davem@davemloft.net> wrote:
> > From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> > Date: Tue, 12 Mar 2013 20:13:15 +0200
> >
> >> @@ -590,10 +590,7 @@ int __init bt_sysfs_init(void)
> >>       bt_debugfs = debugfs_create_dir("bluetooth", NULL);
> >>
> >>       bt_class = class_create(THIS_MODULE, "bluetooth");
> >> -     if (IS_ERR(bt_class))
> >> -             return PTR_ERR(bt_class);
> >> -
> >> -     return 0;
> >> +     return PTR_RET(bt_class)
> >
> > Don't bother submitting patches you aren't even going to try
> > to compile.
> >
> > I'm rejecting all of your current submissions.  Resubmit them
> > when you feel like typing 'make' from time to time.
> >
> >
> 
> Sorry for the trouble caused and sorry for the late reply.
> That being said, I'd like to understand a bit better what exactly I messed up.
> I've just pulled the latest revision of the mainline kernel and made
> the changes in this patch.
> I've tried with make defconfig (which would be x86_64_defconfig in my
> case), followed by
> make menuconfig to select the bluetooth options and make allyesconfig.
> Both defconfig and allyesconfig compile successfully on my system.
> Would you be so kind as to tell me what error you have encountered?
> Or perhaps enlighten me as to what I'm still doing wrong. I'd like to
> learn from my mistakes.

You do have to ensure that the file you modify
is actually compiled.

Sometimes it's easier to type make path/file.o

In any case, this is missing the statement terminating
semicolon after PTR_RET(bt_class).


