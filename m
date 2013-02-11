Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab3BKX0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:26:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45232 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:26:49 -0500
Message-ID: <51197E36.8080704@wwwdotorg.org>
Date: Mon, 11 Feb 2013 16:26:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] of: Fix locking when calling of_get_next_available_child()
References: <1360621157-23570-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360621157-23570-1-git-send-email-grant.likely@secretlab.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 03:19 PM, Grant Likely wrote:
> of_get_next_available_child() obtains the devtree_lock and then calls
> of_device_is_available() which also attempts to claim the lock. This is
> obviously incorrect and causes a deadlock on boot. Fix issue by adding
> an variant of of_device_is_available() which doesn't obtain the lock.

This patch forgets to update __of_device_is_available() to call
__of_get_property() rather than of_get_property() and hence doesn't
actually solve the problem.

You might want to make __of_device_is_available() static too.
