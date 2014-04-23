Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaDWVq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:46:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaDWVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:46:25 -0400
Date: Wed, 23 Apr 2014 14:46:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] autofs - fix lockref lookup
Message-Id: <20140423144624.716f325d454f9debd97bef15@linux-foundation.org>
In-Reply-To: <20140423052035.5999.69412.stgit@perseus.fritz.box>
References: <20140423052035.5999.69412.stgit@perseus.fritz.box>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 13:20:36 +0800 Ian Kent <raven@themaw.net> wrote:

> autofs needs to be able to see private data dentry flags for
> its dentrys that are being created but not yet hashed and for
> its dentys that have been rmdir()ed but not yet freed. It
> needs to do this so it can block processes in these states
> until a status has been returned to indicate the given
> operation is complete.
> 
> It does this by keeping two lists, active and expring, of
> dentrys in this state and uses ->d_release() to keep them
> stable while it checks the reference count to determine
> if they should be used.
> 
> But with the recent lockref changes dentrys being freed
> sometimes don't transition to a reference count of 0 before
> being freed so autofs can occassionally use a dentry that
> is invalid which can lead to a panic.

What's the value of "recent"?  I assume 3.14 is OK?
