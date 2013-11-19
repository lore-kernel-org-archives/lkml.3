Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3KSBHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3KSBHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:07:41 -0500
Date: Mon, 18 Nov 2013 22:48:13 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 06/15] KVM: MMU: redesign the algorithm of pte_list
Message-ID: <20131119004812.GA22049@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382534973-13197-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:24PM +0800, Xiao Guangrong wrote:
> Change the algorithm to:
> 1) always add new desc to the first desc (pointed by parent_ptes/rmap)
>    that is good to implement rcu-nulls-list-like lockless rmap
>    walking
> 
> 2) always move the entry in the first desc to the the position we want
>    to remove when delete a spte in the parent_ptes/rmap （backward-move).
>    It is good for us to implement lockless rmap walk since in the current
>    code, when a spte is deleted from the "desc", another spte in the last
>    "desc" will be moved to this position to replace the deleted one. If the
>    deleted one has been accessed and we do not access the replaced one, the
>    replaced one is missed when we do lockless walk.
>    To fix this case, we do not backward move the spte, instead, we forward
>    move the entry: when a spte is deleted, we move the entry in the first
>    desc to that position
> 
> Both of these also can reduce cache miss
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

