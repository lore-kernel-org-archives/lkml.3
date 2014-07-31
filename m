Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaGaWpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:45:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaGaWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:45:41 -0400
Date: Thu, 31 Jul 2014 15:45:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
Message-Id: <20140731154540.441ab79ff32ae5c10f64bcbd@linux-foundation.org>
In-Reply-To: <53DA0C5A.3010409@codeaurora.org>
References: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org>
	<alpine.DEB.2.02.1407310001360.18238@chino.kir.corp.google.com>
	<53DA0C5A.3010409@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 14:58:58 +0530 Chintan Pandya <cpandya@codeaurora.org> wrote:

> >
> > I think Andrew's comment earlier was referring to the changelog only and
> > not the patch, which looked correct.
> 
> I think Andrew asked for a BUG case details also to justify the 
> overhead. But we have never encountered that BUG case. Present patch is 
> only logical fix to the code. However, in the fast path, if such 
> overhead is allowed, I can move BUG_ON out of any debug configs. 
> Otherwise, as per Andrew's suggestion, I will convert DEBUG_HIGHMEM into 
> DEBUG_VM which is used more frequently.

The v1 patch added a small amount of overhead to kmap_atomic() for what
is evidently a very small benefit.

Yes, I suggest we remove CONFIG_DEBUG_HIGHMEM from the kernel entirely
and switch all CONFIG_DEBUG_HIGHMEM sites to use CONFIG_DEBUG_VM.  That way
the BUG_ON which you believe is useful will be tested by more people
more often.
