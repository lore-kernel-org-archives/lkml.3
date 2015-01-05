Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbbAET4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:56:01 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:44401 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbbAETz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:55:59 -0500
MIME-Version: 1.0
Date: Mon, 5 Jan 2015 11:55:58 -0800
Message-ID: <CAHTgTXUGVkJX26bFSOC9EH2gUynSKhLNr7D8mN8cSy7Km_+f9Q@mail.gmail.com>
Subject: next-timestamp build failure with 3.19-rc2
From: Vinson Lee <vlee@twopensource.com>
To: Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm hitting the following build error with 3.19-rc2 on CentOS 5 with
glibc-headers-2.5-123.

  HOSTCC  Documentation/networking/timestamping/txtimestamp
Documentation/networking/timestamping/txtimestamp.c:64:8: error:
redefinition of ‘struct in6_pktinfo’
 struct in6_pktinfo {
        ^
In file included from /usr/include/arpa/inet.h:23:0,
                 from Documentation/networking/timestamping/txtimestamp.c:33:
/usr/include/netinet/in.h:456:8: note: originally defined here
 struct in6_pktinfo
        ^

The build error was introduced with
cbd3aad5ce66f5a266a185aa37e0eb9be9ba4154 "net-timestamp: expand
documentation and test".

commit cbd3aad5ce66f5a266a185aa37e0eb9be9ba4154
Author: Willem de Bruijn <willemb@google.com>
Date:   Sun Nov 30 22:22:35 2014 -0500

    net-timestamp: expand documentation and test

    Documentation:
      expand explanation of timestamp counter

    Test:
      new: flag -I requests and prints PKTINFO
      new: flag -x prints payload (possibly truncated)
      fix: remove pretty print that breaks common flag '-l 1'

    Signed-off-by: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


Cheers,
Vinson
