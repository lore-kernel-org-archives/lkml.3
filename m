Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3FGT4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:56:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab3FGT4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:56:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <51B1FEB1.8040103@hurleysoftware.com>
References: <51B1FEB1.8040103@hurleysoftware.com> <20130606115417.GA520@x4> <51B09A26.3080603@hurleysoftware.com> <20130606143750.GB520@x4>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: dhowells@redhat.com, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
Date: Fri, 07 Jun 2013 20:56:12 +0100
Message-ID: <30721.1370634972@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley <peter@hurleysoftware.com> wrote:

> Based on the other reports from Mikael and David, I suspect this problem
> may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
> 
>   pty: Ignore slave pty close() if never successfully opened
> 
> This commit poisons the pty under certain error conditions that may
> occur from parallel open()s (or parallel close() with pending write()).

In the case that I'm seeing, the tty in question isn't being opened and closed
regularly.  A gcc build is dumping a load of stuff out through tee and tee
writes it to the tty it got as fd 1 from the parent shell.

David
