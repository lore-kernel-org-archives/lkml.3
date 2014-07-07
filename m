Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaGGNmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:42:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35864 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaGGNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:42:05 -0400
Date: Mon, 7 Jul 2014 14:41:55 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mike Cardwell <linux@lists.grepular.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: /proc/net/ symlink interacts badly with threads (Re: Procfs race
 condition bug)
Message-ID: <20140707144155.7bbcf246@alan.etchedpixels.co.uk>
In-Reply-To: <20140704101311.GA7020@glue.grepular.com>
References: <20140704101311.GA7020@glue.grepular.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014 11:13:11 +0100
Mike Cardwell <linux@lists.grepular.com> wrote:

> I originally posted this two years ago (*) but received no response. I
> just had a look and the problem still exists on the 3.14 kernel I am
> currently running.
> 
> I *think* I've uncovered a race condition bug in procfs. If I attempt to

I don't think you have found a race condition.

/proc/net/tcp is a symbolic link to /proc/self/net/tcp

Your thread does an open of /proc/net/tcp, which is a symlink
to /proc/self/net/tcp. If your thread id matches your process id then all
will be as you expect, if not then all will be pear shaped.

As far as I can see the code is doing precisely what it should do. It's
just that the use of the symlink when namespaces were added produces some
rather odd effects. 

It's certainly a bug. It used to work, it's sensible it should work.

Added netdev

Alan
