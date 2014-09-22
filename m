Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaIVV30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbaIVV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:29:24 -0400
Message-ID: <542094AC.6070908@redhat.com>
Date: Mon, 22 Sep 2014 23:29:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, David Matlack <dmatlack@google.com>
CC: Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <20140922200812.GA9217@amt.cnet>
In-Reply-To: <20140922200812.GA9217@amt.cnet>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 22:08, Marcelo Tosatti ha scritto:
> > This patch does not change functionality, it just makes invalid ioctls
> > fail faster.
> 
> Should not be executing vcpu ioctls without interrupt KVM_RUN in the
> first place.

This is not entirely true, there are a couple of asynchronous ioctls
though they are not used on x86 (commit 2122ff5eab8f, KVM: move vcpu
locking to dispatcher for generic vcpu ioctls, 2010-05-13).

Paolo
