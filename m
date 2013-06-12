Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3FLJPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:15:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab3FLJPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:15:23 -0400
Date: Wed, 12 Jun 2013 11:15:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: prevent memleak with the allocated
 name
In-Reply-To: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1306121114230.6750@pobox.suse.cz>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Benjamin Tissoires wrote:

> mt_free_input_name() was never called during .remove():
> hid_hw_stop() removes the hid_input items in hdev->inputs, and so the
> list is therefore empty after the call. In the end, we never free the
> special names that has been allocated during .probe().
> 
> Restore the original name before freeing it to avoid acessing already
> freed pointer.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I have now applied this one and will send it to Linus for next -rc.

If we are going down the path of using devm API, as proposed by Andy, that 
will require much more throgough review of interaction with input 
subsystem, so definitely not a late -rc regression fix material.

Thanks,

-- 
Jiri Kosina
SUSE Labs
