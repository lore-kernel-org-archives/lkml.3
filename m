Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaGJJdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:33:43 -0400
Received: from canardo.mork.no ([148.122.252.1]:55614 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbaGJJdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:33:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        dingtianhong <dingtianhong@huawei.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v7 10/33] net: dummy - set name assign type
Organization: m
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<1404980258-30853-11-git-send-email-teg@jklm.no>
Date: Thu, 10 Jul 2014 11:31:29 +0200
In-Reply-To: <1404980258-30853-11-git-send-email-teg@jklm.no> (Tom Gundersen's
	message of "Thu, 10 Jul 2014 10:17:15 +0200")
Message-ID: <87pphdh85q.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:

> A fixed number of indistinguishable dummy devices are allocated at module init time,
> the names are therefore PREDICTABLE rather than ENUM.

OK?  So if I go do

 modprobe dummy numdummies=2
 ip link add type dummy
 ip link add type dummy

then I'd have dummy0 and dummy1 with NET_NAME_PREDICTABLE, but dummy2 and
dummy3 with NET_NAME_ENUM (from your rtnetlink patch).

I think this just demonstrates that there aren't that many different
name types.  There is no real difference between your NET_NAME_ENUM and
NET_NAME_PREDICTABLE, resulting in arbitrary choices like this one.

The same goes for NET_NAME_USER and NET_NAME_RENAMED. These are the same
from a kernel point of view.  If userspace wants to keep track of device
name history then it is free to do so without any need for a RENAMED
type.


Bjørn
