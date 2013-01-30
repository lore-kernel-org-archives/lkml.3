Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3A3Lx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:53:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3A3LxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:53:24 -0500
Date: Wed, 30 Jan 2013 12:51:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return
	-EINTR
Message-ID: <20130130115153.GA7012@redhat.com>
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com> <51082470.2070601@suse.cz> <20130129194908.GA29480@redhat.com> <510846AB.8010900@suse.cz> <20130130114645.GA6622@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130114645.GA6622@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Oleg Nesterov wrote:
>
> On 01/29, Jiri Slaby wrote:
> >
> > On 01/29/2013 08:49 PM, Oleg Nesterov wrote:
> > >
> > > Perhaps /bin/bash is buggy too, I do not know. Probably Roman and
> > > Lingzhu can tell more.
> >
> > But I really want to hear more details here (the commit log deserves
> > that). E.g. why it started causing problems right now.
>
> I have no idea, I only saw the test-case yesterday.

But if you ask how this affects /bin/bash, I can quote the description
from Lingzhu,

	sigchld.sh (reproducer):

	#!/bin/bash
	( while :; do kill -CHLD $$ 2>&- || break; done ) &
	while :; do
		read -p 1 -t 0.3 -d ' '
		read -p 2
	done

	Double free happens in read_builtin, here

	    FREE (tofree);
	->  xfree (orig_input_string);

	    return (retval);

result:

	sigchld.sh: line 4: read: error setting terminal attributes: Interrupted system call
	1
	*** glibc detected *** ./bash-4.1.2-14.el6/bin/bash: double free or corruption (out): 0x00000000020f45b0 ***
	======= Backtrace: =========
	(...)

Oleg.

