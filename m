Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaAVPWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:22:48 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60769 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaAVPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:22:46 -0500
Date: Wed, 22 Jan 2014 09:22:39 -0600
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com
Subject: Re: kvm virtio ethernet ring on guest side over high throughput
 (packet per second)
Message-ID: <20140122152239.GA11404@stefanha-thinkpad.redhat.com>
References: <CAMrG31x0H1OjtNfdcXq2EqZ20XPHCX8qvrQSSuMqR=hsttYmXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMrG31x0H1OjtNfdcXq2EqZ20XPHCX8qvrQSSuMqR=hsttYmXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:06:05PM -0200, Alejandro Comisario wrote:

CCed Michael Tsirkin and Jason Wang who work on KVM networking.

> Hi guys, we had in the past when using physical servers, several
> throughput issues regarding the throughput of our APIS, in our case we
> measure this with packets per seconds, since we dont have that much
> bandwidth (Mb/s) since our apis respond lots of packets very small
> ones (maximum response of 3.5k and avg response of 1.5k), when we
> where using this physical servers, when we reach throughput capacity
> (due to clients tiemouts) we touched the ethernet ring configuration
> and we made the problem dissapear.
> 
> Today with kvm and over 10k virtual instances, when we want to
> increase the throughput of KVM instances, we bumped with the fact that
> when using virtio on guests, we have a max configuration of the ring
> of 256 TX/RX, and from the host side the atached vnet has a txqueuelen
> of 500.
> 
> What i want to know is, how can i tune the guest to support more
> packets per seccond if i know that's my bottleneck?

I suggest investigating performance in a systematic way.  Set up a
benchmark that saturates the network.  Post the details of the benchmark
and the results that you are seeing.

Then, we can discuss how to investigate the root cause of the bottleneck.

> * does virtio exposes more packets to configure in the virtual ethernet's ring ?

No, ring size is hardcoded in QEMU (on the host).

> * does the use of vhost_net helps me with increasing packets per
> second and not only bandwidth?

vhost_net is generally the most performant network option.

> does anyone has to struggle with this before and knows where i can look into ?
> there's LOOOOOOOOOOOOOOOTS of information about networking performance
> tuning of kvm, but nothing related to increase throughput in pps
> capacity.
> 
> This is a couple of configurations that we are having right now on the
> compute nodes:
> 
> * 2x1Gb bonded interfaces (want to know the more than 20 models we are
> using, just ask for it)
> * Multi queue interfaces, pined via irq to different cores
> * Linux bridges,  no VLAN, no open-vswitch
> * ubuntu 12.04 kernel 3.2.0-[40-48]
