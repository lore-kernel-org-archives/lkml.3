Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3HAV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:27:18 -0400
Received: from mail-wi0-f195.google.com ([209.85.212.195]:52996 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3HAV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:27:16 -0400
MIME-Version: 1.0
Date: Thu, 1 Aug 2013 15:09:06 -0600
Message-ID: <CAOpSVYqHbQ9K0Op7NRB1vH17YOKpaGsmFkavwxTO0vu=BC3swg@mail.gmail.com>
Subject: Invalid checksum calculated for ipv4 SYN+ACK when opt.srr is set?
From: Jeroen van Bemmel <jvb127@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Although rarely used and considered plain evil by some, the kernel
code allows one to use IP source routing for TCP.

In tcp_v4_send_synack the following two lines of code are used:
[...]
__tcp_v4_send_check(skb, ireq->loc_addr, ireq->rmt_addr);
[...]
err = ip_build_and_send_pkt(skb, sk, ireq->loc_addr,ireq->rmt_addr,ireq->opt);

In ip_build_and_send_pkt the 'daddr' parameter is used as follows:
iph->daddr = (opt && opt->opt.srr ? opt->opt.faddr : daddr);

It looks like the checksum may be off when (opt && opt->opt.srr ) is true?

Thanks,
Jeroen
