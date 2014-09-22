Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaIVXAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaIVXAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:00:49 -0400
Date: Mon, 22 Sep 2014 20:00:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140922230029.GA12293@amt.cnet>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
 <20140922200812.GA9217@amt.cnet>
 <542094AC.6070908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542094AC.6070908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:29:16PM +0200, Paolo Bonzini wrote:
> Il 22/09/2014 22:08, Marcelo Tosatti ha scritto:
> > > This patch does not change functionality, it just makes invalid ioctls
> > > fail faster.
> > 
> > Should not be executing vcpu ioctls without interrupt KVM_RUN in the
> > first place.
> 
> This is not entirely true, there are a couple of asynchronous ioctls
> though they are not used on x86 (commit 2122ff5eab8f, KVM: move vcpu
> locking to dispatcher for generic vcpu ioctls, 2010-05-13).
> 
> Paolo

Alright. 

s/Should not be executing vcpu ioctls/Should not be executing vcpu
ioctls which take vcpu mutex/


