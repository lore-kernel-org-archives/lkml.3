Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3HZC1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:27:23 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44206 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HZC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:27:22 -0400
Message-ID: <521ABD33.7070905@gmail.com>
Date: Mon, 26 Aug 2013 10:28:03 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: zhuyj <zyjzyj2000@gmail.com>
Subject: ipv6 global address remains while route item disappears after this
 interface is restared in 2.6.34.x
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With two directly connected targets running kernel 2.6.34.x.

TargetA ------------------------- TargetB
3000::1/64                        3000::2/64

TargetA
    - bring the interface down by doing an "ifconfig eth1 down"
    - bring the interface back up by doing an "ifconfig eth1 up"

TargetB
    - ping6 3000::1
      ping6 succeeds the first time
    - after bringing the interface on TargetA down and then back up, 
ping6 to the interface fails.

The root cause is:
IPv6 address 3000::1/64 remains while the ipv6 route on eth1 disappears. 
Thus on TargetB, running "ping6 3000::1" can not succeed.
Compared with 3.4.x, ipv6 address and ipv6 route item are removed when 
an interface is restarted in the.

Best Regards!

zhuyj
