Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaBMSct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:32:49 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51862 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaBMScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:32:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1402131117120.16734@blackhole.kfki.hu>
References: <CAKb7UvhsLi2Sv4SWA2nVTgoFV8dzrY=3R1-SUk9D-aa0VdizSA@mail.gmail.com>
	<alpine.DEB.2.10.1402131117120.16734@blackhole.kfki.hu>
Date: Thu, 13 Feb 2014 10:32:45 -0800
Message-ID: <CAHA+R7MeEEfqz-7RhCUjsoWPx_BKHVXFV3Y32xjf0B1WwjNdRQ@mail.gmail.com>
Subject: Re: ip_set: protocol %u message -- useful?
From: Cong Wang <cwang@twopensource.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>, Vitaly Lavrov <lve@guap.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 2:30 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Thu, 13 Feb 2014, Ilia Mirkin wrote:
>> messages in my dmesg. This might be because of some local
>> configuration changes I've made, or perhaps a kernel upgrade. Either
>> way, it appears this message has been a pr_notice since the original
>> code added it in a7b4f989a62 ("netfilter: ipset: IP set core
>> support").
>>
>> Does this message provide a lot of value? Or could it be made into a pr_debug?
>
> That's a report message on the protocol version used by the ipset
> subsystem. There was (and possibly will be) multiple protocols, so it
> helps to catch basic userpsace/kernelspace communication issues.

But still it doesn't deserve a pr_notice()... pr_info() should be enough.

diff --git a/net/netfilter/ipset/ip_set_core.c
b/net/netfilter/ipset/ip_set_core.c
index de770ec..5ea063f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1945,7 +1945,7 @@ ip_set_net_init(struct net *net)
                return -ENOMEM;
        inst->is_deleted = 0;
        rcu_assign_pointer(inst->ip_set_list, list);
-       pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
+       pr_info("ip_set: protocol %u\n", IPSET_PROTOCOL);
        return 0;
 }
