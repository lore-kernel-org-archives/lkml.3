Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaAaSTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:19:00 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:50428 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaAaSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:18:59 -0500
Date: Fri, 31 Jan 2014 19:18:58 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Jesse Gross <jesse@nicira.com>
Cc: "discuss@openvswitch.org" <discuss@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ovs-discuss] Linus GIT Head OOPs reproducable in open vswitch
 when running mininet topology
Message-ID: <20140131181857.GA25034@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Jesse Gross <jesse@nicira.com>,
	"discuss@openvswitch.org" <discuss@openvswitch.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140130204424.GB19093@glanzmann.de>
 <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
 <20140131023307.GD19871@glanzmann.de>
 <CAEP_g=8nzs+bRwoF99akReFO46SFa4KJ9Bw=UL0LpwbqwHvO+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEP_g=8nzs+bRwoF99akReFO46SFa4KJ9Bw=UL0LpwbqwHvO+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jesse,

> Do you know what type of devices are being attached to OVS (i.e. tap,
> veth, etc.)?

my e-mail has a link to the debug log which contains that Information.
But from my understanding there are several tap devices: one per host,
4-5 per switch. Tap because it needs layer 2.

There are the last commands that are issued before it crashes:

*** Starting controller
*** Starting 4 switches
s1 *** s1 : ('ifconfig lo up',)
*** s1 : ('ovs-vsctl del-br', <OVSSwitch s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None,s1-eth4:None pid=6694> )
*** s1 : ('ovs-vsctl add-br', <OVSSwitch s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None,s1-eth4:None pid=6694> )
*** s1 : ('ovs-vsctl -- set Bridge', <OVSSwitch s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None,s1-eth4:None pid=6694> , 'other_config:datapath-id=0000000000000001')
*** s1 : ('ovs-vsctl set-fail-mode', <OVSSwitch s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None,s1-eth4:None pid=6694> , 'secure')
*** s1 : ('ovs-vsctl add-port', <OVSSwitch s1: lo:127.0.0.1,s1-eth1:None,s1-eth2:None,s1-eth3:None,s1-eth4:None pid=6694> , <Intf s1-eth1>)

and than it hangs. I think the last add-port command triggers it.

> Do you know if this happens with an older kernel or with a simpler topology?

No, I don't. I just verified that the Ubuntu Mininet uses the
openvswitch kernel module from openvswitch and not the one that is
shipped with the kernel. Ubuntu precise does not crash with the exact same
topology.

(ubuntu) [~] modinfo openvswitch
filename:
/lib/modules/3.2.0-58-generic/updates/dkms/openvswitch.ko
license:        GPL
description:    Open vSwitch switching datapath
srcversion:     7CBEB285B79D96D51E0C633
depends:
vermagic:       3.2.0-58-generic SMP mod_unload modversions

Cheers,
        Thomas
