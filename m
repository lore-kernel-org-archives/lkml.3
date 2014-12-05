Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaLEHfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:35:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaLEHfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:35:37 -0500
Message-ID: <5481602E.1030508@redhat.com>
Date: Fri, 05 Dec 2014 15:35:10 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Pankaj Gupta <pagupta@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, dgibson@redhat.com,
        vfalico@gmail.com, edumazet@google.com, vyasevic@redhat.com,
        hkchu@google.com, wuzhy@linux.vnet.ibm.com, xemul@parallels.com,
        therbert@google.com, bhutchings@solarflare.com, xii@google.com,
        stephen@networkplumber.org, jiri@resnulli.us,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 net-next 2/2 tuntap: Increase the number of queues
 in tun.
References: <1417591177-7985-1-git-send-email-pagupta@redhat.com> <1417591177-7985-3-git-send-email-pagupta@redhat.com> <20141203095210.GC9487@redhat.com> <1417661734.16500.0@smtp.corp.redhat.com> <20141204102013.GC17122@redhat.com>
In-Reply-To: <20141204102013.GC17122@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/04/2014 06:20 PM, Michael S. Tsirkin wrote:
> On Thu, Dec 04, 2014 at 03:03:34AM +0008, Jason Wang wrote:
>> > 
>> > 
>> > On Wed, Dec 3, 2014 at 5:52 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>>> > >On Wed, Dec 03, 2014 at 12:49:37PM +0530, Pankaj Gupta wrote:
>>>> > >> Networking under kvm works best if we allocate a per-vCPU RX and TX
>>>> > >> queue in a virtual NIC. This requires a per-vCPU queue on the host
>>>> > >>side.
>>>> > >> It is now safe to increase the maximum number of queues.
>>>> > >> Preceding patche: 'net: allow large number of rx queues'
>>> > >
>>> > >s/patche/patch/
>>> > >
>>>> > >> made sure this won't cause failures due to high order memory
>>>> > >> allocations. Increase it to 256: this is the max number of vCPUs
>>>> > >> KVM supports.
>>>> > >> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
>>>> > >> Reviewed-by: David Gibson <dgibson@redhat.com>
>>> > >
>>> > >Hmm it's kind of nasty that each tun device is now using x16 memory.
>>> > >Maybe we should look at using a flex array instead, and removing the
>>> > >limitation altogether (e.g. make it INT_MAX)?
>> > 
>> > But this only happens when IFF_MULTIQUEUE were used.
> I refer to this field:
>         struct tun_file __rcu   *tfiles[MAX_TAP_QUEUES];
> if we make MAX_TAP_QUEUES 256, this will use 4K bytes,
> apparently unconditionally.
>
>

How about just allocate one tfile if IFF_MULTIQUEUE were disabled?

