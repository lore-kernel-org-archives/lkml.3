Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175Ab3DQXid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893Ab3DQXia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:38:30 -0400
Date: Wed, 17 Apr 2013 20:38:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce invalid rmap handlers
Message-ID: <20130417233810.GD31059@amt.cnet>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1366093973-2617-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366093973-2617-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 02:32:45PM +0800, Xiao Guangrong wrote:
> Invalid rmaps is the rmap of the invalid memslot which is being
> deleted, especially, we can treat all rmaps are invalid when
> kvm is being destroyed since all memslot will be deleted soon.
> MMU should remove all sptes on these rmaps before the invalid
> memslot fully deleted
> 
> The reason why we separately handle invalid rmap is we want to
> unmap invalid-rmap out of mmu-lock to achieve scale performance
> on intensive memory and vcpu used guest

Better try to make the code simpler, and introduce complexity only 
if necessary.

The idea to zap the roots is very elegant and apparently effective. What
are its problems?

