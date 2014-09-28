Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaI1XMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 19:12:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51535 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaI1XMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 19:12:43 -0400
Date: Mon, 29 Sep 2014 00:12:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does inotify work with special files such as
 /proc/<pid>/task/<tid>/children?
Message-ID: <20140928231240.GC7996@ZenIV.linux.org.uk>
References: <fb54b1e8bb54.5428953e@langara.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb54b1e8bb54.5428953e@langara.bc.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:09:50PM +0000, Steven Stewart-Gallus wrote:
> Hello,
> 
> I can't seem to get inotify to work with special files such as
> /proc/<pid>/task/<tid>/children? I just need to get a simple yes/no
> answer on whether it works for special files or whether I have to try
> a different approach.

Simple answer: No.  Slightly more expanded one: No, and it won't.
Inotify does not work on procfs, sysfs, etc.  Doesn't work on
network filesystems either.  Don't use it.  It was a mistake in the
first place.
