Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3IIMds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:33:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IIMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:33:47 -0400
Date: Mon, 9 Sep 2013 15:33:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909123329.GZ19256@mwanda>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906151255.GE2238@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 06:12:55PM +0300, Sergey Senozhatsky wrote:
> Calling handle_pending_slot_free() for every RW operation may
> cause unneccessary slot_free_lock locking, because most likely
> process will see NULL slot_free_rq. handle_pending_slot_free()
> only when current detects that slot_free_rq is not NULL.
> 
> v2: protect handle_pending_slot_free() with zram rw_lock.
> 

zram->slot_free_lock protects zram->slot_free_rq but shouldn't the zram
rw_lock be wrapped around the whole operation like the original code
does?  I don't know the zram code, but the original looks like it makes
sense but in this one it looks like the locks are duplicative.

Is the down_read() in the original code be changed to down_write()?

regards,
dan carpenter

