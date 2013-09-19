Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3ISOMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:12:19 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:53847 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab3ISOMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:12:15 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: usbip-devel@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>, Joe Perches <joe@perches.com>,
        Bart Westgeest <bart@elbrys.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Bernard Blackham <b-linuxgit@largestprime.net>,
        Harvey Yang <harvey.huawei.yang@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] staging: usbip: Extend crypto support
Date: Thu, 19 Sep 2013 16:11:52 +0200
Message-Id: <1379599919-24763-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series extends our previous set of patches (see [1]). We extended
the crypto support so all of the usbip network traffic can now be completely
encrypted and authenticated.

We now use GnuTLS not only for password verification, but extend the lifetime
of the TLS connection to cover all of the userland communications.  Before
handing over the connection to the kernel, two randomly generated 128 bit
session keys are exchanged between client and server and stored in sysfs
together with the sockfd. The kernel uses these keys to encrypt and
authenticate all of the traffic using AES-GCM and the linux crypto API.
Separate keys are used for both directions of the data channel.

To the best of our knowledge, the implemented encryption should provide decent
security. However, it still lacks complete review; we also note that in the
documentation.

As mentioned in the project README, the network protocol needs more discussion.
This series increments the protocol version, because the improved crypto
support breaks compatibility with the previous patch series[1]. In the long
term, the protocol should be extended to support proper feature negotiation. If
both patch series are merged as one, the protocol version increment can be
omitted - both patch series are compatible with unauthenticated transport, but
are incompatible with each other.

Regards,
	Tobias Polzer and Dominik Paulus

[1] <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>,
    https://lkml.org/lkml/2013/9/13/104

