Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaJ2Thu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:37:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2Ths (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:37:48 -0400
Date: Wed, 29 Oct 2014 15:37:45 -0400 (EDT)
Message-Id: <20141029.153745.182320154112584088.davem@davemloft.net>
To: jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, kyeyoonp@codeaurora.org
Subject: Re: randconfig build error with next-20141028, in net/bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+r1ZhjGo_pWi5hsxra65fCm0kwLfit4ai4_sAiwKKj0fPLxVg@mail.gmail.com>
References: <CA+r1ZhjGo_pWi5hsxra65fCm0kwLfit4ai4_sAiwKKj0fPLxVg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Oct 2014 12:37:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Davis <jim.epost@gmail.com>
Date: Tue, 28 Oct 2014 07:52:47 -0700

> Building with the attached random configuration file,
> 
> net/built-in.o: In function `br_handle_frame_finish':
> (.text+0x40edf): undefined reference to `arp_tbl'
> net/built-in.o: In function `br_handle_frame_finish':
> (.text+0x40f3a): undefined reference to `arp_send'
> make: *** [vmlinux] Error 1

Kyeyoon-ssi, you will need to do something about this.

Your choices are either selecting INET (and thus also
CRYPTO and CRYPTO_AES, since INET needs those in order
to build properly), making bridging depeng on INET,
or protecting the new proxy-arp code with INET ifdef
checks.
