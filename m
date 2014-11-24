Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaKXDXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 22:23:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaKXDXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 22:23:32 -0500
Message-ID: <5472A499.60906@redhat.com>
Date: Mon, 24 Nov 2014 11:23:05 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>
CC: pagupta@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dgibson@redhat.com, vfalico@gmail.com, edumazet@google.com,
        vyasevic@redhat.com, hkchu@google.com, wuzhy@linux.vnet.ibm.com,
        xemul@parallels.com, therbert@google.com, bhutchings@solarflare.com,
        xii@google.com, stephen@networkplumber.org, jiri@resnulli.us,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-net 0/4] Increase the limit of tuntap queues
References: <1416327778-17716-1-git-send-email-pagupta@redhat.com> <20141119.151628.768548269128919029.davem@davemloft.net> <20141119204427.GB30994@redhat.com> <20141123104623.GA31915@redhat.com>
In-Reply-To: <20141123104623.GA31915@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2014 06:46 PM, Michael S. Tsirkin wrote:
> On Wed, Nov 19, 2014 at 10:44:27PM +0200, Michael S. Tsirkin wrote:
>> > On Wed, Nov 19, 2014 at 03:16:28PM -0500, David Miller wrote:
>>> > > From: Pankaj Gupta <pagupta@redhat.com>
>>> > > Date: Tue, 18 Nov 2014 21:52:54 +0530
>>> > > 
>>>> > > > - Accept maximum number of queues as sysctl param so that any user space 
>>>> > > >   application like libvirt can use this value to limit number of queues. Also
>>>> > > >   Administrators can specify maximum number of queues by updating this sysctl
>>>> > > >   entry.
>>> > > 
>>> > > This is the only part I don't like.
>>> > > 
>>> > > Just let whoever has privileges to configure the tun device shoot
>>> > > themselves in the foot if they want to by configuring "too many"
>>> > > queues.
>>> > > 
>>> > > If the virtual entity runs itself out of resources by doing something
>>> > > stupid, it's purely their problem.
>> > 
>> > Well it will run host out of kernel, no?
> To clarify:
>
> At the moment attaching/detaching queues is an unpriveledged operation.
>
> Shouldn't we worry that an application can cause large
> allocations, and provide a way to limit these?

But creating new queues (TUNSETIFF) is privileged. There's no way for
unprivileged user to allocate more resources. So we are safe here?
