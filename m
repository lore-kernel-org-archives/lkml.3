Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaHDSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:02:21 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35648 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaHDSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140801191340.GN18016@ZenIV.linux.org.uk>
References: <1406909172-7219-1-git-send-email-jharris@westell.com>
	<20140801165607.GM18016@ZenIV.linux.org.uk>
	<CAGMfbUPOMKVkZuZtzoN-w5pTpjHMzYhrdaM2WuBdm7RSMsNYAw@mail.gmail.com>
	<20140801191340.GN18016@ZenIV.linux.org.uk>
Date: Mon, 4 Aug 2014 14:02:19 -0400
Message-ID: <CAGMfbUMua7uZR16G1-r4+DwoPP2k5C3TQDNQkvbCO4RFwRm-+A@mail.gmail.com>
Subject: Re: [PATCH] jffs2: Re-enable write-buffering after filesystem sync
From: Jeff Harris <jefftharris@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Harris <jharris@westell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 3:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Why do we need ->wbuf_queued, anyway?  It's not as if queue_delayed_work()
> wouldn't do the right thing - if the sucker already has WORK_STRUCT_PENDING_BIT
> set it'll simply do nothing.  And it won't spend much time finding that
> out - in fact, it'll be cheaper than what we do right now.
>
> IOW, how about the following (completely untested):
>

I tested the patch against our 3.13 device, and it appears to resolve
the original
write-buffering after sync problem we were having.  I did not do any
other regression
testing, though.

Jeff
