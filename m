Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaIWANe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:13:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaIWANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:13:32 -0400
Date: Mon, 22 Sep 2014 21:13:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140923001308.GA13962@amt.cnet>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
 <20140922200812.GA9217@amt.cnet>
 <20140922225816.GD8347@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922225816.GD8347@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:58:16PM -0700, David Matlack wrote:
> > Should not be executing vcpu ioctls without interrupt KVM_RUN in the
> > first place.
> 
> This patch is trying to be nice to code that isn't aware it's
> probing kvm file descriptors. We saw long hangs with some generic
> process inspection code that was probing all open file descriptors.
> There's no reason non-kvm ioctls should have to wait for the vcpu
> mutex to become available just to fail.

OK then, please add the usecase to the changelog.

