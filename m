Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbaJ3RRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:17:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32943 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaJ3RRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:17:22 -0400
Date: Thu, 30 Oct 2014 10:17:08 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Miller <davem@davemloft.net>
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        kyeyoonp@codeaurora.org
Subject: Re: randconfig build error with next-20141028, in net/bridge
Message-ID: <20141030101708.12113903@urahara>
In-Reply-To: <20141029.153745.182320154112584088.davem@davemloft.net>
References: <CA+r1ZhjGo_pWi5hsxra65fCm0kwLfit4ai4_sAiwKKj0fPLxVg@mail.gmail.com>
	<20141029.153745.182320154112584088.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 15:37:45 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Jim Davis <jim.epost@gmail.com>
> Date: Tue, 28 Oct 2014 07:52:47 -0700
> 
> > Building with the attached random configuration file,
> > 
> > net/built-in.o: In function `br_handle_frame_finish':
> > (.text+0x40edf): undefined reference to `arp_tbl'
> > net/built-in.o: In function `br_handle_frame_finish':
> > (.text+0x40f3a): undefined reference to `arp_send'
> > make: *** [vmlinux] Error 1
> 
> Kyeyoon-ssi, you will need to do something about this.
> 
> Your choices are either selecting INET (and thus also
> CRYPTO and CRYPTO_AES, since INET needs those in order
> to build properly), making bridging depeng on INET,
> or protecting the new proxy-arp code with INET ifdef
> checks.

Maybe make ARP proxy a config option under bridge and have
it depend on INET?
