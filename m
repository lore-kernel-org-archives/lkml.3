Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaJQIOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:14:55 -0400
Received: from mail-a05.ithnet.com ([217.64.83.100]:39155 "EHLO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753762AbaJQIOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:14:47 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 04:14:46 EDT
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Fri, 17 Oct 2014 10:08:01 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: How to find the correct source address to a destination in a kernel
 driver?
Message-Id: <20141017100801.f1c310de.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.18; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

in former kernels with routing cache things were easy. We just used :

        rt = ip_route_output_key(XXX)
        src = rt->rt_src;

Now if there is no routing cache, we tried this:

        rt = ip_route_output_key(XXX)
        src = inet_select_addr(rt->dst.dev, dst, RT_SCOPE_UNIVERSE);

Unfortunately this does not work with interfaces having multiple ip addresses
and the routing in question is not over the first configured ip.
How do I get the correct src for all possible cases?

-- 
Regards,
Stephan
