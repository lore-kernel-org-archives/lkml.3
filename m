Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbaKTQbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:31:48 -0500
Received: from mx6-phx2.redhat.com ([209.132.183.39]:49814 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaKTQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:31:47 -0500
Date: Thu, 20 Nov 2014 11:31:28 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
To: Cong Wang <cwang@twopensource.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dgibson@redhat.com,
        vfalico@gmail.com, Eric Dumazet <edumazet@google.com>,
        Vladislav Yasevich <vyasevic@redhat.com>, Jerry Chu <hkchu@google.com>,
        wuzhy@redhat.com, Pavel Emelyanov <xemul@parallels.com>,
        Tom Herbert <therbert@google.com>, bhutchings@solarflare.com,
        xii@google.com, Stephen Hemminger <stephen@networkplumber.org>,
        =?utf-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <497267937.1868067.1416501088558.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAHA+R7MnLy=8uL_hSnx=BN2QTs2kvempTxtmSO6hjcS+E0yRwg@mail.gmail.com>
References: <1416327778-17716-1-git-send-email-pagupta@redhat.com> <1416327778-17716-2-git-send-email-pagupta@redhat.com> <CAHA+R7MnLy=8uL_hSnx=BN2QTs2kvempTxtmSO6hjcS+E0yRwg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: allow large number of rx queues
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF23 (Linux)/8.0.6_GA_5922)
Thread-Topic: allow large number of rx queues
Thread-Index: xZtevcfWsX8Xh/f3KwKQ0QqqwT2kzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Nov 18, 2014 at 8:22 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
> >
> > As vmalloc() adds overhead on a critical network path,
> > __GFP_REPEAT flag is used with kzalloc() to do this fallback
> > only when really needed.
> >
> 
> Are you sure we need __GFP_REPEAT? We have vmalloc() as
> fallback of kmalloc() in many places of networking (grep kvfree),
> none of those I checked has this flag set.

Its there in netif_alloc_netdev_queues() function in same file.
Also, I found it some other places as well.
I think its good to have.
> 
