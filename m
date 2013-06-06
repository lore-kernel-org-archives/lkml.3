Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3FFQOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:14:16 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62666 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3FFQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:14:13 -0400
Message-ID: <1370535252.24311.357.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] Fix lockup related to stop_machine being stuck in
 __do_softirq.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: greearb@candelatech.com
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Date: Thu, 06 Jun 2013 09:14:12 -0700
In-Reply-To: <1370535006-3467-1-git-send-email-greearb@candelatech.com>
References: <1370535006-3467-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 09:10 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The stop machine logic can lock up if all but one of
> the migration threads make it through the disable-irq
> step and the one remaining thread gets stuck in
> __do_softirq.  The reason __do_softirq can hang is
> that it has a bail-out based on jiffies timeout, but
> in the lockup case, jiffies itself is not incremented.
...
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2:  Fix comments and reformat conditional per suggestions.
> 

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


