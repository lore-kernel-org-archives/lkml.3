Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaI2AoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:44:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54840 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaI2AoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:44:10 -0400
Date: Sun, 28 Sep 2014 19:44:07 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: Does inotify work with special files such as
 /proc/<pid>/task/<tid>/children?
Message-ID: <20140928194407.3a584b78@as>
In-Reply-To: <20140928231240.GC7996@ZenIV.linux.org.uk>
References: <fb54b1e8bb54.5428953e@langara.bc.ca>
	<20140928231240.GC7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 00:12:40 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sun, Sep 28, 2014 at 11:09:50PM +0000, Steven Stewart-Gallus wrote:
> > Hello,
> > 
> > I can't seem to get inotify to work with special files such as
> > /proc/<pid>/task/<tid>/children? I just need to get a simple yes/no
> > answer on whether it works for special files or whether I have to try
> > a different approach.
> 
> Simple answer: No.  Slightly more expanded one: No, and it won't.
> Inotify does not work on procfs, sysfs, etc.  Doesn't work on
> network filesystems either.  Don't use it.  It was a mistake in the
> first place.

Why was inotify a mistake? Was it badly implemented, or is the whole
concept of userspace being able to monitor filesystem changes
basically impossible to do correctly?
