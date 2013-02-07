Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3BGLD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:03:27 -0500
Received: from mail-ph.de-nserver.de ([85.158.179.214]:42857 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab3BGLDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:03:25 -0500
Message-ID: <51138866.8000802@profihost.ag>
Date: Thu, 07 Feb 2013 11:56:38 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Netdev List <netdev@vger.kernel.org>
CC: kaber@trash.net, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre DERUMIER <aderumier@odiso.com>
Subject: Problem with GVRP on eth while having a bridge
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

this was tested using vanilla 3.7.6 kernel.

When i add a vlan to an ethernet device supporting gvrp everything is
fine until this ethernet device also had a bridge.

This works fine as long as eth1 is not attached to a bridge.

# ip link add link eth1 name eth1.99 type vlan id 99 gvrp on
# ip link set eth1.99 up

The dynamic VLAN stays up at the switch - no problems.

If eth1 has a bridge the dynamic vlan is created at the switch so the
initial packet was send but it disappears after a few seconds.

Wireshark shows that the kernel has stopped sending GVRP packets. After
adding a bridge to eth1.

Greets,
Stefan

