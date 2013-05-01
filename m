Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587Ab3EAPy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:54:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35661 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761541Ab3EAPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:54:51 -0400
Date: Wed, 1 May 2013 08:54:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Love <rlove@google.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
In-Reply-To: <1367416573-5430-1-git-send-email-rlove@google.com>
Message-ID: <alpine.DEB.2.02.1305010853450.4547@chino.kir.corp.google.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Robert Love wrote:

> Don't acquire ashmem_mutex in ashmem_shrink if we've somehow recursed into the
> shrinker code from within ashmem. Just bail out, avoiding a deadlock. This is
> fine, as ashmem cache pruning is advisory anyhow.
> 
> Signed-off-by: Robert Love <rlove@google.com>

Any reason not to send this to stable@vger.kernel.org if it fixes an 
observable deadlock?  (It's annotated to be applied to linux-next, but I 
don't see any differences between it and Linus's tree.)
