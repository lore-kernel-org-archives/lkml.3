Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaAUSNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:13:32 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:42666 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaAUSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:13:30 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 13:13:30 EST
MIME-Version: 1.0
From: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Date: Tue, 21 Jan 2014 16:06:05 -0200
Message-ID: <CAMrG31x0H1OjtNfdcXq2EqZ20XPHCX8qvrQSSuMqR=hsttYmXQ@mail.gmail.com>
Subject: kvm virtio ethernet ring on guest side over high throughput (packet
 per second)
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, we had in the past when using physical servers, several
throughput issues regarding the throughput of our APIS, in our case we
measure this with packets per seconds, since we dont have that much
bandwidth (Mb/s) since our apis respond lots of packets very small
ones (maximum response of 3.5k and avg response of 1.5k), when we
where using this physical servers, when we reach throughput capacity
(due to clients tiemouts) we touched the ethernet ring configuration
and we made the problem dissapear.

Today with kvm and over 10k virtual instances, when we want to
increase the throughput of KVM instances, we bumped with the fact that
when using virtio on guests, we have a max configuration of the ring
of 256 TX/RX, and from the host side the atached vnet has a txqueuelen
of 500.

What i want to know is, how can i tune the guest to support more
packets per seccond if i know that's my bottleneck?

* does virtio exposes more packets to configure in the virtual ethernet's ring ?
* does the use of vhost_net helps me with increasing packets per
second and not only bandwidth?

does anyone has to struggle with this before and knows where i can look into ?
there's LOOOOOOOOOOOOOOOTS of information about networking performance
tuning of kvm, but nothing related to increase throughput in pps
capacity.

This is a couple of configurations that we are having right now on the
compute nodes:

* 2x1Gb bonded interfaces (want to know the more than 20 models we are
using, just ask for it)
* Multi queue interfaces, pined via irq to different cores
* Linux bridges,  no VLAN, no open-vswitch
* ubuntu 12.04 kernel 3.2.0-[40-48]


any help will be incredibly apreciated !!

thank you.
