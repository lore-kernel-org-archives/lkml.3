Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbaGXTCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:02:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:55123 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440AbaGXTCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:02:13 -0400
Date: Thu, 24 Jul 2014 15:02:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Message-ID: <20140724190206.GL6673@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:21:38AM -0700, Andy Lutomirski wrote:
> >
> > Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
> > future extension ?
> 
> This might actually be needed sooner rather than later.  There are
> programs that use containers and intentionally don't pass /dev/random
> through into the container.  I know that Sandstorm does this, and I
> wouldn't be surprised if other things (Docker?) do the same thing.

I wouldn't add the error to the man page until we actually modify the
kernel to add such a restriction.

However, the thought crossed my mind a while back that perhaps the
right answer is a cgroup controller which controls the rate at which a
process is allowed to drain entropy from the /dev/random pool.  This
could be set to 0, or it could be set to N bits per unit time T, and
if the process exceeded the value, it would just block or return
EAGAIN.  So instead of making it be just a binary "you have access" or
"you don't", it would actually be a kernel resource that could be
controlled just like disk bandwidth, networking bandwidth, memory, and
CPU time.

Then I decided that it was overkill, but for people who are trying to
treat containers as a way to divide up OS resources between mutually
suspicious customers in a fashion which is more efficient thatn using
VM's, maybe it is something that someone will want to implement.

      	       	  	    	 	    	- Ted
