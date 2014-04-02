Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaDBQnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:43:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaDBQnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:43:52 -0400
Date: Wed, 2 Apr 2014 17:43:42 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] serial: 8250, disable "too much work" messages
Message-ID: <20140402174342.1f78a39e@alan.etchedpixels.co.uk>
In-Reply-To: <533BDC4F.3060903@suse.cz>
References: <1396352220-5031-1-git-send-email-jslaby@suse.cz>
	<20140401144057.63b3ceb5@alan.etchedpixels.co.uk>
	<533BDC4F.3060903@suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, according to Takashi's measurements, we would need over 15000 loops
> on a single port. Of course, this value is highly dependent on a system.
> On my system, it is like 7 times lower (2100). And it lasts ~300ms here.
> 
> I suppose a limit like 32k loops is way too much and I just should go
> and implement the polling. Or what about adding inter-character sleeps
> to qemu to correspond to the speed? I can do that too, but I am not sure
> if limiting the throughput will be accepted by them.

The other option would be to detect qemu as a buggy uart, log a warning
and ignore the test on it. I think polling might be better, and that
would probably fix hang cases on real buggy uarts where right now we
sometimes keel over.

