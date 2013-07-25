Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3GYIbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:31:00 -0400
Received: from smtp209.alice.it ([82.57.200.105]:48755 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3GYIay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:30:54 -0400
Date: Thu, 25 Jul 2013 10:30:28 +0200
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, gustavo@padovan.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_port: Fix refcounting leak in tty_port_tty_hangup()
Message-ID: <20130725083028.GA8203@sottospazio.it>
References: <1374729977-7164-1-git-send-email-gianluca@sottospazio.it>
 <51F0C525.8080506@suse.cz>
 <20130725081436.GA8057@sottospazio.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725081436.GA8057@sottospazio.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:14:36AM +0200, Gianluca Anzolin wrote:
> On Thu, Jul 25, 2013 at 08:26:45AM +0200, Jiri Slaby wrote:
> > On 07/25/2013 07:26 AM, Gianluca Anzolin wrote:
> > > The function tty_port_tty_hangup() could leak a reference to the tty_struct:
> > > 
> > >         struct tty_struct *tty = tty_port_tty_get(port);
> > > 
> > >         if (tty && (!check_clocal || !C_CLOCAL(tty))) {
> > >                 tty_hangup(tty);
> > >                 tty_kref_put(tty);
> > >         }
> > > 
> > > If tty != NULL and the second condition is false we never call tty_kref_put and
> > > the reference is leaked.
> > > 
> > > Fix by always calling tty_kref_put() which accepts a NULL argument.
> > > 
> > > The patch fixes a regression introduced by commit aa27a094.
> > > 
> > > Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> > > Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
> > 
> > Acked-by: Jiri Slaby <jslaby@suse.cz>
> > 
> > Thanks for the fix.
> > 
> 
> Hi,
> 
> I sent this morning a newer fix changed following the instructions of Peter
> Hurley. Could you apply that fix instead?
> 
> Thank you,
> 
> Gianluca

Disregard that, that one was the right fix.

Thanks,
Gianluca
