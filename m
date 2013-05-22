Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3EVUsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3EVUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:28 -0400
Date: Wed, 22 May 2013 13:48:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 06/14] bcon: add a release work struct
Message-Id: <20130522134827.2bc71496cda3e2849958c15c@linux-foundation.org>
In-Reply-To: <1368132193-25817-9-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-9-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:43:04 -0400 Joern Engel <joern@logfs.org> wrote:

> The final bcon_put() can be called from atomic context, by way of
> bio_endio().  In that case we would sleep in invalidate_mapping_pages(),
> with the usual unhappy results.
> 
> In nearly a year of production use, I have only seen a matching
> backtrace once.  There was a second known issue that could be reproduced
> by "yes h > /proc/sysrq-trigger" and concurrently pulling and replugging
> the blockconsole device.  It took be somewhere around 30 pulls and sore
> thumbs to reproduce and I never found the time to get to the bottom of
> it.  Quite likely the two issues are identical.

This fix should be folded into the base patch?
