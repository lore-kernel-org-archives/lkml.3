Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3EHSNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:13:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62776 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3EHSNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:13:14 -0400
Date: Thu, 9 May 2013 02:13:04 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Convert all to the caller hold lock version
Message-ID: <20130508181304.GA12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 50e244cc793d511b86adea24972f3a7264cae114 
     (fb: rework locking to fix lock ordering on takeover)
and 
     commit e93a9a868792ad71cdd09d75e5a02d8067473c4e
     (fb: Yet another band-aid for fixing lockdep mess)

We have two version functions implement almost the same function,
except the caller/callee hold lock.

fbcon_takeover vs do_fbcon_takeover
register_con_driver vs do_register_con_driver
take_over_console vs do_take_over_console
unbind_con_driver vs do_unbind_con_driver
bind_con_driver vs do_bind_con_driver
unregister_con_driver vs do_unregister_con_driver

This issue bring us much code duplication,
like do_fbcon_takeover and fbcon_takeover,
they have almost the same.

Although some of them had been re-written 
as a wrapper for another, but the wrapper
is so trivial, we can just throw them away.

Also those two versions of almost the same
functions will confuse API's user.

After all, I think this issue is not good
for long time maintain.

This series patch convert all to the
new version which caller hold the lock,
and then delete the old version away.

Thanks


