Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3EaV4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:56:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44988 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017Ab3EaV4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:56:39 -0400
Message-ID: <1370037388.10556.86.camel@joe-AO722>
Subject: Re: [PATCH 2/3] pktcdvd: Convert printk to pr_<level>
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 31 May 2013 14:56:28 -0700
In-Reply-To: <CAHp75Vdt22imDXu0phvbAVz=D-ctXH_JV6eMZ457e4d+=Tj0=Q@mail.gmail.com>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
	 <cover.1369947186.git.joe@perches.com>
	 <be5d8d48c70deec2d883e122732522ced3bd6246.1369947186.git.joe@perches.com>
	 <CAHp75Vdt22imDXu0phvbAVz=D-ctXH_JV6eMZ457e4d+=Tj0=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 22:44 +0300, Andy Shevchenko wrote:
> On Thu, May 30, 2013 at 11:57 PM, Joe Perches <joe@perches.com> wrote:
> > Use a more current logging style and add messages levels
> > to the logging messages.
> >
> > Convert bare printks to pr_cont where appropriate and
> > add a simple function to emit the sense string.
> 
> Few comments below.
> 
> Why not dev_dbg wherever it's possible?

Because dev_<level> conversions are not appropriate for a
first pass.  The "struct pktcdvd *" needs to be available
for more function calls and that's more work / less
automatic and this pass is more easily verified.

> > -       printk(DRIVER_NAME":");
> > +       pr_err("");
> >         for (i = 0; i < CDROM_PACKET_SIZE; i++)
> > -               printk(" %02x", cgc->cmd[i]);
> > -       printk(" - ");
> > +               pr_cont(" %02x", cgc->cmd[i]);
> 
> This one is actually %*ph.
> 
> Like: pr_info("%*ph", CDROM_PACKET_SIZE, cgc->cmd);
> 
> And what is the level of this message? debug?

pr_err and good point about %*ph, I've fixed it and
the stupid typo around the #include here.

