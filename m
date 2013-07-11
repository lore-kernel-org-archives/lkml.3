Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3GKWXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:23:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3GKWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:08 -0400
Date: Thu, 11 Jul 2013 15:20:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: turn vma_set_policy() into
 vma_dup_policy()
Message-Id: <20130711152006.de0900cfcd784f2833285ee4@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com>
References: <20130710170205.GA26425@redhat.com>
	<alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013 15:13:03 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> > +int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
> > +{
> > +	struct mempolicy *pol = mpol_dup(vma_policy(src));
> > +
> > +	if (IS_ERR(pol))
> > +		return PTR_ERR(pol);
> 
> PTR_ERR() returns long, so vma_dup_policy() needs to return long.

hm, really?  vma_dup_policy() returns an errno and errnos have type "int".

Arguably it is PTR_ERR() which returns the wrong type...
