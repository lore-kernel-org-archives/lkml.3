Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3CSN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:57:17 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:33539 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3CSN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:57:15 -0400
Message-ID: <1363701429.7084.2.camel@thor.lan>
Subject: Re: [PATCH 4/7] n_tty: Encapsulate minimum_to_wake within N_TTY
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 09:57:09 -0400
In-Reply-To: <20130318231538.GA16280@kroah.com>
References: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
	 <1362577105-19757-5-git-send-email-peter@hurleysoftware.com>
	 <20130318231538.GA16280@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 16:15 -0700, Greg Kroah-Hartman wrote:
> On Wed, Mar 06, 2013 at 08:38:22AM -0500, Peter Hurley wrote:
> > minimum_to_wake is unique to N_TTY processing, and belongs in
> > per-ldisc data.
> > 
> > Add the ldisc method, ldisc_ops::fasync(), to notify line disciplines
> > when signal-driven I/O is enabled or disabled. When enabled for N_TTY
> > (by fcntl(F_SETFL, O_ASYNC)), blocking reader/polls will be woken
> > for any readable input. When disabled, blocking reader/polls are not
> > woken until the read buffer is full.
> > 
> > Canonical mode (L_ICANON(tty), n_tty_data::icanon) is not affected by
> > the minimum_to_wake setting.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> For some reason, this patch doesn't apply.  Care to refresh this one,
> and the rest in this series, and resend?

Sorry. There was probably some accidental dependency on one of the other
patchsets of mine you did apply.

This and patch 5 now apply without error to tty-next.



