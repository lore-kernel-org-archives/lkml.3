Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCXOAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:00:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47865 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXOAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:00:10 -0400
Date: Mon, 24 Mar 2014 14:00:01 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-ID: <20140324140001.00200e83@alan.etchedpixels.co.uk>
In-Reply-To: <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The whole point of __GFP_NOFAIL is to centralise this
> wait-for-memory-for-ever operation.  So it is implemented in a common
> (core) place and so that we can easily locate these problematic
> callers.

For reiserfs I'm not sure it's worth bothering. If you get an out of
memory or disk caused block read failure in the wrong location it'll copy
random data over low physical memory (its one of several filesystems
which happily memcpy to errno values)

Making reiserfs go away would be a much better long term option IMHO

Alan
