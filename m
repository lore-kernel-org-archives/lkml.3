Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3KYMsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:48:40 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34993 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3KYMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:48:38 -0500
MIME-Version: 1.0
In-Reply-To: <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<20131122191429.GA13308@amt.cnet>
	<65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 14:48:37 +0200
Message-ID: <CAEbWaipqSpf4PdRo6YD=xBjucdWjZrs0Mibfi+jJeF7uj-NaCw@mail.gmail.com>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
From: Avi Kivity <avi.kivity@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 8:11 AM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
>
> On Nov 23, 2013, at 3:14 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

<snip complicated stuff about parent_pte>

I'm not really following, but note that parent_pte predates EPT (and
the use of rcu in kvm), so all the complexity that is the result of
trying to pack as many list entries into a cache line can be dropped.
Most setups now would have exactly one list entry, which is handled
specially antyway.

Alternatively, the trick of storing multiple entries in one list entry
can be moved to generic code, it may be useful to others.
