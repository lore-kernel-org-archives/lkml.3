Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275Ab3E2WDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:03:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2WDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:03:44 -0400
Date: Wed, 29 May 2013 15:03:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: Re: [PATCH] cciss: fix broken mutex usage in ioctl
Message-Id: <20130529150342.7f16e4402c82227604931984@linux-foundation.org>
In-Reply-To: <20130524192841.21256.51523.stgit@beardog.cce.hp.com>
References: <20130524192841.21256.51523.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 14:28:41 -0500 "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> If a new logical drive is added and the CCISS_REGNEWD ioctl is invoked
> (as is normal with the Array Configuration Utility) the process
> will hang as below.  It attempts to acquire the same mutex twice, once
> in do_ioctl() and once in cciss_unlocked_open().  The BKL was recursive,
> the mutex isn't.

huh, now that's a really old-school deadlock.  I wonder why lockdep
didn't shout about it.

