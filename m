Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaIQUd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:33:29 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:40700 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaIQUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:33:26 -0400
MIME-Version: 1.0
Date: Wed, 17 Sep 2014 23:33:25 +0300
Message-ID: <CAHZKCCaAkuwhxX7C0KFSABo-eLu56THibrk3XrPvRXmj7EJh+g@mail.gmail.com>
Subject: AF_INET SOCK_RAW questions.
From: Me Registered <me.registered@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While "reading" the kernel sources referring to AF_INET SOCK_RAW
sockets, i have stumbled upon some particular issues:

* in raw_icmp_error. why is the marked line required?
 290                         raw_err(raw_sk, skb, info);
 291                         raw_sk = sk_next(raw_sk);
*292                         iph = (const struct iphdr *)skb->data; // <<<<<<
 293                 }
 294         }

looking over raw_err, the skb is not changed and i don't think that it
is meant to since that means delivering different thinks to different
sockets, while iterating. (i have tracked this line back to
2.4.3.2->2.4.3.3).

* also in raw_bind:
why is there no lock_sock/release_sock while changing socket
attributes (like in rawv6_bind)?

Thanks,
Bogdan B.
