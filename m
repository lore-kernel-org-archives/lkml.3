Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936149AbaFHVd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 17:33:26 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:61250 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaFHVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 17:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzRWZNt2AqdVzQpCChB1UJh12oBAof8UiKsvNGSMUe9BA@mail.gmail.com>
References: <20140607123518.88983301D2@webmail.sinamail.sina.com.cn>
	<CA+55aFzRWZNt2AqdVzQpCChB1UJh12oBAof8UiKsvNGSMUe9BA@mail.gmail.com>
Date: Sun, 8 Jun 2014 14:33:16 -0700
X-Google-Sender-Auth: R_RHXYxZMWvzKnDRG4fkwmJlP-k
Message-ID: <CA+55aFxu2agkdu1ixbUP_XGy0ckyyOP_jOQ=LyyMRiVfAgS_NA@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: zhdxzx@sina.com
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, dhillf <dhillf@gmail.com>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 11:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Comments? Mel, this code is mostly attributed to you, I'd like to hear
> what you think in particular.

In the meantime, I've removed the "nr_unqueued_dirty == nr_taken"
check for congestion_wait(), since I can't see how it can possibly be
sensible, and Felipe confirmed that it fixes his interactivity issue.

Nobody commented on it, but let's see if we get reactions to the
behavior changing..

             Linus
