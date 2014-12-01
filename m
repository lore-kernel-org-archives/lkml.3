Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaLALp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:45:56 -0500
Received: from mail-ob0-f194.google.com ([209.85.214.194]:40664 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaLALpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:45:55 -0500
MIME-Version: 1.0
Date: Mon, 1 Dec 2014 15:45:54 +0400
Message-ID: <CABV6-SW3F6+Tzv8zK=CJqPxWc4xTx6NSt5vyGQRsemcaesuLLg@mail.gmail.com>
Subject: no connectivity on PF with Intel 82599/SR-IOV/OVS
From: "Dmitry N." <plretbox@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all.

I'm having an issue with SR-IOV on 82599 NIC in lab env. Basically
what I have is Ubuntu 12.04 with a set of vanilla kernels and Open
vSwitch.

A simplified scheme for ovs setup:
br-mgmt -> [vlan 102]br-eth0 -> eth0 -> fabric

When VFs are disabled, connectivity works fine. However when at least
one VF is enabled, traffic just doesn't go any further than br-eth0.
Oddly enough, it acts this way only if VLAN is configured on br-eth0
via OVS. When I try to configure VLAN with ip link, it works just
fine.

It's not an udev issue because re-adding eth0 to br-eth0 doesn't help.
I've tried different OVS and ixgbe/ixgbevf versions against different
kernel versions and ruled out issues with OVS and ixgbe.

This could be a kernel bug.

Kernel versions I've tried:
3.11.0 works fine
3.12.24 has this issue
3.14.23 has this issue
3.15.10 has this issue
3.16.7 and later kernels: the situation is opposite: when VFs are
disabled, there is no connectivity on PF; as soon as at leas 1 VF is
enabled, connectivity appears.

OVS versions:
2.3.0 for user space
2.3.0 (and kernel native where 2.3.0 is not supported - starting with
3.15.x) for kernel space

ixgbe:
latest from Intel website (3.22.3)

ixgbevf:
latest from Intel website (2.15.3)

Any suggestions? Thanks.
