Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3FKDPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:15:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49173 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3FKDPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:15:31 -0400
Date: Tue, 11 Jun 2013 04:15:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS/lazy-umount/path-lookup-related panics at shutdown (at kill
 of processes on lazy-umounted filesystems) with 3.9.2 and 3.9.5
Message-ID: <20130611031529.GD4165@ZenIV.linux.org.uk>
References: <871u89vp46.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u89vp46.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 06:42:49PM +0100, Nix wrote:
> Yes, my shutdown scripts are panicking the kernel again! They're not
> causing filesystem corruption this time, but it's still fs-related.
> 
> Here's the 3.9.5 panic, seen on an x86-32 NFS client using NFSv3: NFSv4
> was compiled in but not used. This happened when processes whose
> current directory was on one of those NFS-mounted filesystems were being
> killed, after it had been lazy-umounted (so by this point its cwd was in
> a disconnected mount point).

Hrm...  Could you post (or drop on anonftp, etc.) disassembly of path_init() from
your kernel?  The code quoted in oops looks very odd...
