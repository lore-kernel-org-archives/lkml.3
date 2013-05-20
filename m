Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3ETT1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:27:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3ETT1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:27:38 -0400
Date: Mon, 20 May 2013 12:27:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, alan@linux.intel.com,
        airlied@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Convert all to the caller hold lock version
Message-ID: <20130520192737.GA20961@kroah.com>
References: <20130508181304.GA12344@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508181304.GA12344@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 02:13:04AM +0800, Wang YanQing wrote:
> After commit 50e244cc793d511b86adea24972f3a7264cae114 
>      (fb: rework locking to fix lock ordering on takeover)
> and 
>      commit e93a9a868792ad71cdd09d75e5a02d8067473c4e
>      (fb: Yet another band-aid for fixing lockdep mess)
> 
> We have two version functions implement almost the same function,
> except the caller/callee hold lock.
> 
> fbcon_takeover vs do_fbcon_takeover
> register_con_driver vs do_register_con_driver
> take_over_console vs do_take_over_console
> unbind_con_driver vs do_unbind_con_driver
> bind_con_driver vs do_bind_con_driver
> unregister_con_driver vs do_unregister_con_driver
> 
> This issue bring us much code duplication,
> like do_fbcon_takeover and fbcon_takeover,
> they have almost the same.
> 
> Although some of them had been re-written 
> as a wrapper for another, but the wrapper
> is so trivial, we can just throw them away.
> 
> Also those two versions of almost the same
> functions will confuse API's user.
> 
> After all, I think this issue is not good
> for long time maintain.
> 
> This series patch convert all to the
> new version which caller hold the lock,
> and then delete the old version away.

Can you also send a patch fixing up the documentation to use the new
functions as well?

thanks,

greg k-h
