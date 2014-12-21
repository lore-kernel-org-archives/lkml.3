Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaLUXrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:47:21 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47598 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLUXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:47:19 -0500
Date: Sun, 21 Dec 2014 17:47:14 -0600
From: Eric Biggers <ebiggers3@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] rtl8192se: panic accessing unmapped memory in skb
Message-ID: <20141221234714.GA30675@zzz>
References: <20141221172516.GA12784@zzz>
 <5497516A.2020400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5497516A.2020400@lwfinger.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To get your patched version to work at all I had to update
_rtl_pci_init_rx_ring() to account for new return value of
_rtl_pci_init_one_rxdesc().  I will let you know if anything shows up in the
kernel log, but I expect this is a highly sporadic problem.  The system has 4 GB
of memory, and I used the 3.18 kernel for 10 days prior to the panic with no
issues.  The panic occurred while upgrading system packages, so it's possible
jhat the system was experiencing memory pressure.

I upgraded from 3.17 to 3.18 on Dec 8, so I've actually only had since then to
notice any bugs that may have been introduced since 3.17.

It does appear there were changes made to pci.c between 3.17 and 3.18.  It
appears the 3.17 code will drop the incoming packet if a new skb can't be
allocated, whereas the 3.18 code assumes a new skb can always be allocated.  The
3.17 behavior seems more logical to me.  I don't know how either of these
behaviors compare to other networking drivers, however.

Eric
