Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbaGYScx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:32:53 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45228 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760803AbaGYScu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuxjvR-3cBq=x0d_7qYtF+TP3NdjPxsYP6pn4iE7gzLhpg@mail.gmail.com>
References: <1406275499-7822-1-git-send-email-ast@plumgrid.com>
 <53D23EAF.4000001@redhat.com> <20140725115414.GA4770@salvia>
 <CA+FuTScUJ-oJKAZ-MO_t9Rmah3U6G4sjHXLJSMrXVK5+fN0zyg@mail.gmail.com> <CAMEtUuxjvR-3cBq=x0d_7qYtF+TP3NdjPxsYP6pn4iE7gzLhpg@mail.gmail.com>
From: Willem de Bruijn <willemb@google.com>
Date: Fri, 25 Jul 2014 14:32:19 -0400
Message-ID: <CA+FuTSeKpu7u=KyGeiWpEDLWgxkPDRUtSc9fixR93jxsTCkc0g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: filter: rename 'struct sk_filter' to
 'struct bpf_prog'
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This follows a convention in include/uapi/linux/netfilter/*.h that
>> likely predates the introduction of uapi. A search for "Used
>> internally by the kernel" shows many more examples. I should not have
>> included filter.h, however. The common behavior when using pointers
>> to kernel-internal structures is to have a forward declaration. I suggest
>> making that change, instead of changing to void *. This avoids having
>> to add casts where xt_bpf_info is used in net/netfilter/xt_bpf.c:
>
> that will not avoid typecast.
> Either 'void *' approach or extra 'struct sk_filter;' approach, both need
> type casts to 'struct bpf_prog' in xt_bpf.c
> (because of SK_RUN_FILTER macro)
> Therefore I prefer extra 'struct sk_filter;' approach.

I hadn't noticed that your patch makes the same change that I
proposed. Nothing in userspace should touch that pointer, so it is
fine to change its type to struct bpf_prog* at the same time. No need
for typecasts.
