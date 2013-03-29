Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3C2BAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:00:54 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:57158 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3C2BAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130328113222.194bbfe8@cuia.bos.redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5151DBD3.6080201@oracle.com>
	<20130328113222.194bbfe8@cuia.bos.redhat.com>
Date: Thu, 28 Mar 2013 18:00:52 -0700
Message-ID: <CANN689E30ORoTO75Xr=AknoHy+1ts7awi=4a3Jef31L6M2gMdQ@mail.gmail.com>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with find_alloc_undo
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 8:32 AM, Rik van Riel <riel@surriel.com> wrote:
> The ipc semaphore code has a nasty RCU locking tangle, with both
> find_alloc_undo and semtimedop taking the rcu_read_lock(). The
> code can be cleaned up somewhat by only taking the rcu_read_lock
> once.
>
> The only caller of find_alloc_undo is in semtimedop.
>
> This should solve the trinity issue reported by Sasha Levin.
>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Looks good^Wbetter. I have nothing specific to say other than I've
been staring at it for 10 minutes :)

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
