Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3DWAhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:37:40 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:53245 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3DWAhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:37:38 -0400
Message-ID: <1366677456.16391.101.camel@edumazet-glaptop>
Subject: Re: socket file descriptor a/m/c-timestamps broken in <= 3.8.8?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Felix Becker <mail@felixbecker.name>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 22 Apr 2013 17:37:36 -0700
In-Reply-To: <20130423003015.GA26858@dcvr.yhbt.net>
References: <5175CA2F.2030206@felixbecker.name>
	 <20130423003015.GA26858@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 00:30 +0000, Eric Wong wrote:
> Cc:-ing netdev (no comments of my own)
> 
> Felix Becker <mail@felixbecker.name> wrote:
> > Hi,
> > 
> > I tried to figure out how old my TCP connections are and took a look
> > at /proc/<pid>/fd/<socketfdnum> using 'ls -la' / 'stat'.
> > 

Thanks, but its not a network issue, /proc/pid/fd are part of another
subsystem.

In particular, a/m/c timestamps are volatile (not meaningfull), as you
can make them disappear by 
"echo 3 >/proc/sys/vm/drop_caches"

Next time you use "ls /proc/pid/fd/..." timestamps are created.



