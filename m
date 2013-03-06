Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3CFNnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:43:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab3CFNnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:43:11 -0500
Date: Wed, 6 Mar 2013 08:40:04 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Message-ID: <20130306084004.05acd57c@tlielax.poochiereds.net>
In-Reply-To: <CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q@mail.gmail.com>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAH2r5muojf9w9QxkPK5vCQs5Av_wxm+twJ044+Mf8Q_9D=b63Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 16:08:30 -0600
Steve French <smfrench@gmail.com> wrote:

> Resending patch to a slightly broader list for last minute check if
> anyone objects.  Although setting this particular socket option
> (TCP_NODELAY) may not be as useful when corking/uncorking explicitly,
> I want to doublecheck before removing them because there has been some
> utility to the server allowing override of various sockopt options.
> Samba server has long supported at least the following set of settable
> socket options (although I don't know if the defaults are frequently
> overridden now, by setting sockopts in smb.conf as used to be common
> for the server).
> 
> SO_KEEPALIVE
> SO_REUSEADDR
> SO_BROADCAST
> TCP_NODELAY
> IPTOS_LOWDELAY
> IPTOS_THROUGHPUT
> SO_SNDBUF *
> SO_RCVBUF *
> SO_SNDLOWAT *
> SO_RCVLOWAT *
> 
> * takes an integer argument rather than a boolean on/off
> 
> Any objections to removing the ability to set socket options
> explicitly for the cifs network file system client?
> 

A couple of points...

The sockopt= option was never documented in the mount.cifs manpage and
the only value it ever accepted was TCP_NODELAY. Now that we're
explicitly corking the socket, TCP_NODELAY has no effect. I don't think
there's any value in leaving in a "placeholder" socket= option.

-- 
Jeff Layton <jlayton@redhat.com>
