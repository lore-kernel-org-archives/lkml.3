Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab3JKTrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:47:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3JKTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:47:22 -0400
Date: Fri, 11 Oct 2013 12:47:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: giometti@enneenne.com, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
Message-Id: <20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
In-Reply-To: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 14:40:32 +0200 Paul Chavent <Paul.Chavent@onera.fr> wrote:

> The PPS_FETCH ioctl is blocking still the reception of a PPS
> event. But, in some case, one may immediately need the last event
> date. This patch allow to get the result of PPS_FETCH if the device
> has the O_NONBLOCK flag set.

Are the PPS ioctls actually documented anywhere? 
Documentation/pps/pps.txt is silent.

That's a shame, because it would be nice to have a formal description
of the the PPS_FETCH semantics which leads to an understanding of why
things are the way they are, how PPS_FETCH is supposed to be used, etc.

Also, the presence of such documentation would permit me to bug you for
not having updated it!  We need *some* channel for telling people about
the driver, and updates to it.  Maybe linuxpps.org has it somewhere,
but I couldn't immediately find it.

Your implementation requires that the file be opened non-blocking.  But
I'd have thought that adding a new and separate ioctl mode would be a
cleaner and more flexible implementation - that way an app which wants
both blocking and non-blocking behaviour doesn't need to open the file
twice.

Also, this is actually a non-backward-compatible change for any
application which happened to be opening the file with O_NONBLOCK! 
Hopefully there aren't any such applications...


