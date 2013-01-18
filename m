Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3ARAmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:42:24 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33021 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3ARAmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:42:23 -0500
Date: Thu, 17 Jan 2013 16:42:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/3] zram: force disksize setting before using zram
Message-ID: <20130118004219.GB29380@kroah.com>
References: <1358388769-30112-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358388769-30112-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:12:47AM +0900, Minchan Kim wrote:
> Now zram document syas "set disksize is optional"
> but partly it's wrong. When you try to use zram firstly after
> booting, you must set disksize, otherwise zram can't work because
> zram gendisk's size is 0. But once you do it, you can use zram freely
> after reset because reset doesn't reset to zero paradoxically.
> So in this time, disksize setting is optional.:(
> It's inconsitent for user behavior and not straightforward.
> 
> This patch forces always setting disksize firstly before using zram.
> Yes. It changes current behavior so someone could complain when
> he upgrades zram. Apparently it could be a problem if zram is mainline
> but it still lives in staging so behavior could be changed for right
> way to go. Let them excuse.

I don't know about changing this behavior.  I need some acks from some
of the other zram developers before I can take this, or any of the other
patches in this series.

thanks,

greg k-h
