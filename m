Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3E0R5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:57:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3E0R5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:57:13 -0400
Message-ID: <51A39E71.70900@redhat.com>
Date: Mon, 27 May 2013 13:57:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/4] ipc/sem: seperate wait-for-zero and alter tasks into
 seperate queues
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-3-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369559335-13491-3-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:08 AM, Manfred Spraul wrote:
> Introduce seperate queues for operations that do not modify the
> semaphore values.
> Advantages:
> - Simpler logic in check_restart().
> - Faster update_queue(): Right now, all wait-for-zero operations
>    are always tested, even if the semaphore value is not 0.
> - wait-for-zero gets again priority, as in linux <=3.0.9

Whether this complexity is wanted is not for
me to decide, as I am not the ipc/sem.c
maintainer. I'll leave that up to Andrew and Linus.

The code looks correct, though.

Acked-by: Rik van Riel <riel@redhat.com>

