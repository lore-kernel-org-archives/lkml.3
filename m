Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3BTVcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:32:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19513 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230Ab3BTVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:32:52 -0500
Message-ID: <512540E6.7070302@oracle.com>
Date: Wed, 20 Feb 2013 16:32:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org>
In-Reply-To: <20130220210116.GD3570@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 04:01 PM, Tejun Heo wrote:
> Recent idr updates make idr_find() trigger WARN_ON_ONCE() before
> returning NULL when a negative ID is specified.  Apparently,
> posix-timer::__lock_timer() was depending on idr_find() returning NULL
> on negative ID, thus triggering the new WARN_ON_ONCE().  Make
> __lock_timer() first check whether @timer_id is negative and return
> NULL without invoking idr_find() if so.
> 
> Note that the previous code was theoretically broken.  idr_find()
> masked off the sign bit before performing lookup and if the matching
> IDs were in use, it would have returned pointer for the incorrect
> entry.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
> Sasha, can you please test whether this makes the warning go away?

Looks like it did.


Thanks,
Sasha
