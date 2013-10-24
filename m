Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3JXLom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:44:42 -0400
Received: from www84.your-server.de ([213.133.104.84]:52656 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3JXLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:44:41 -0400
Message-ID: <1382615080.2236.19.camel@wall-e.seibold.net>
Subject: Re: [PATCH] add new prctl for a per process wide close on exec
From: Stefani Seibold <stefani@seibold.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org
Date: Thu, 24 Oct 2013 13:44:40 +0200
In-Reply-To: <20131022194836.GZ13318@ZenIV.linux.org.uk>
References: <1382470038-1220-1-git-send-email-stefani@seibold.net>
	 <20131022194836.GZ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 22.10.2013, 20:48 +0100 schrieb Al Viro:
> On Tue, Oct 22, 2013 at 09:27:18PM +0200, Stefani Seibold wrote:
> 
> > This patch will increase security since no developers can review all libraries
> > which there are using. Also in a team of developers it is not always possible
> > to have a full survey over the code which is produced. Or the output of a code
> > generators and so one. This patch allows a kind of preventive measures.
> > 
> > It can also prevent resource occupation. Imagine a long running process (a
> > daemon) is execute from the application after open some file desciptors. For
> > example libpcsclite.so will not open the socket with SOCK_CLOEXEC. Or a device
> > driver which alows only a single open. In both cases the resource cannot
> > reopened after a close. Sigh!
> > 
> > What do you think?
> 
> That it's a bad idea.  Not to mention anything else, the same unreviewed
> libraries can get buggered if the program sets that "global close-on-exec"
> and it's not at all obvious whether the breakage from that change will be less
> or more dangerous than leaking opened files to children.
> 
> Al, fully expecting the Linux S-M crowd to jump on that one and come up with
> yet another one-shot LSM... ;-/

You are right, but only in a perfect world ;-)

It is not always possible to review a library, f.e. on my current gentoo
system currently 20853 libraries installed. And what is with binary only
libraries or closed source code?

And that a library is using the new PR_CLOEXEC is IMHO very constructed.
But if this will happen (what i not believe), this should be very easy
to be locate and fixed.

I think you compare pears with apples, a simple prctl is not a LSM. A
lot of developer asked for this kind of global CLOEXEC functionality.
Try google... Tt adds only about 200 bytes to the current Linux code. 

Linux must cope with the UNIX legacy, but 99,9999 percent of programs
does not depend on the inheritance of file descriptors other than STDIO.
The UNIX default behaviour passing all fd's to the child is still
stupid. I think this is a nice solution for a long standing legacy
issue.

A lot of legacy UNIX issues was addressed and fixed by the linux kernel
with new system-calls or special behaviour. Why not this?

Greetings,
Stefani


