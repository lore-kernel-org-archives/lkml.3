Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab3BKWjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:39:11 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:38279 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab3BKWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:39:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: fix recursive locking in of_get_next_available_child()
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1360617332-2738-1-git-send-email-swarren@wwwdotorg.org>
References: <1360617332-2738-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 11 Feb 2013 22:39:07 +0000
Message-Id: <20130211223907.271653E3530@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 14:15:32 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> of_get_next_available_child() acquires devtree_lock, then calls
> of_device_is_available() which calls of_get_property() which calls
> of_find_property() which tries to re-acquire devtree_lock, thus causing
> deadlock.
> 
> To avoid this, create a new __of_device_is_available() which calls
> __of_get_property() instead, which calls __of_find_property(), which
> does not take the lock,. Update of_get_next_available_child() to call
> the new __of_device_is_available() since it already owns the lock.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks for looking at this Stephen. I ended up applying my version of
this patch though just because it was more convenient to do so. It was
pretty much identical anyway.

g.
