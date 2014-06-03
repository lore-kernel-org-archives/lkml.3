Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaFCMsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:48:40 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:45160 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaFCMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:48:38 -0400
Message-ID: <538DC422.1050303@redhat.com>
Date: Tue, 03 Jun 2014 14:48:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
References: <1401744482-17764-1-git-send-email-mst@redhat.com>	<1401744482-17764-3-git-send-email-mst@redhat.com> <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/06/2014 23:58, Eric Dumazet ha scritto:
> This looks dubious
>
> What about using kfree_rcu() instead ?

It would lead to unbound allocation from userspace.

> translate_desc() still uses rcu_read_lock(), its not clear if the mutex
> is really held.

Yes, vhost_get_vq_desc must be called with the vq mutex held.

The rcu_read_lock/unlock in translate_desc is unnecessary.

Paolo
