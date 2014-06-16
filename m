Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaFPM50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:57:26 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:34746 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaFPM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:57:24 -0400
X-Fcrdns: No
Message-ID: <539EE86E.6030806@profihost.ag>
Date: Mon, 16 Jun 2014 14:51:58 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: stephen@networkplumber.org, David Miller <davem@davemloft.net>
CC: bridge@lists.linux-foundation.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: netconsole breaks netpoll on bridge
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm using a vanilla 3.10.43 kernel and netconsole on top of a bridge.

netconsole is used with vmbr0 (bridge) which is on top of bond0.

If i want to add another bridge to vmbr0 is fails as long as netconsole
is in use.

# brctl addif vmbr0 fwpr2004p0
can't add fwpr2004p0 to bridge vmbr0: Unknown error 524

Kernel output:
netpoll: (null): fwpr2004p0 doesn't support polling, aborting

If i do rmmod netconsole - everything is working fine again.

Greets,
Stefan
