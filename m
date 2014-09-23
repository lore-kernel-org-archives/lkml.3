Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaIWENE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:13:04 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51215 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIWENC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:13:02 -0400
Date: Tue, 23 Sep 2014 00:12:58 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923041258.GA27067@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923140633.35efbe7a@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On Tue, Sep 23, 2014 at 02:06:33PM +1000, NeilBrown wrote:
>  When mdmon needs to update metadata after a device failure in an array
>  there are two 'kmalloc' sources that can trigger deadlock if memory is tight
>  and needs to be written to the array (which cannot be allowed until mdmon
>  updates the metadata).
>  One is in O_DIRECT writes which I have patches for.  The other is when
>  writing to the sysfs file to tell md that it is safe to continue.
>  This simple patch removes the second.

Ugh... :( If this can't be avoided at all, I'd much prefer it to be
something explicit - a flag marking the file as needing a persistent
write buffer which is allocated on open.  "Small" writes on stack
feels way to implicit to me.

Thanks.

-- 
tejun
