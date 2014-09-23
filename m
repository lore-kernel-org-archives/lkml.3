Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaIWGtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:49:24 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51676 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaIWGtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:49:22 -0400
Date: Tue, 23 Sep 2014 09:49:18 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140923064918.GE30733@minantech.com>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
 <541FFEDE.9030800@redhat.com>
 <542027F6.4050205@de.ibm.com>
 <542032D4.305@redhat.com>
 <54207668.3030502@de.ibm.com>
 <5420788F.9050208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5420788F.9050208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:29:19PM +0200, Paolo Bonzini wrote:
> Il 22/09/2014 21:20, Christian Borntraeger ha scritto:
> > "while using trinity to fuzz KVM, we noticed long stalls on invalid ioctls. Lets bail out early on invalid ioctls". or similar?
> 
> Okay.  David, can you explain how you found it so that I can make up my
> mind?
> 
> Gleb and Marcelo, a fourth and fifth opinion? :)
> 
I agree with Christian that simpler fix is better here.
The overhead is minimal. If we ever notice this overhead
we can revert the patch all together since the problem it
fixes can only be inflicted on userspace by itself and there
are myriads other ways userspace can hurt itself.

--
			Gleb.
