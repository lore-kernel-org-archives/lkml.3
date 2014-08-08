Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaHHG5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:57:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7730 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbaHHG5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:57:47 -0400
Date: Fri, 8 Aug 2014 14:55:33 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dmitry Popov <ixaphire@qrator.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Weird NET_RX softirq behavior
Message-ID: <20140808145533.5675e695@xhacker>
In-Reply-To: <1407476878.3604.0.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140807171050.77819b10@xhacker>
	<20140807181813.37b73927513266381d55ad0d@qrator.net>
	<20140808103734.677bff7e@xhacker>
	<1407476878.3604.0.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-08_02:2014-08-06,2014-08-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408080082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 22:47:58 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Fri, 2014-08-08 at 10:37 +0800, Jisheng Zhang wrote:
> > nd and recive 7 packets so far, about 1400bytes. Seems small
> > comparing with the CPU1 and CPU2 NET_RX softirq numbers, right?
> > 
> > Any other possible case?
> 
> Multicast loop. Check dev_loopback_xmit() and its callers.
> 
> 

That's it! This make sense

I didn't see any NET_RX on CPU1,2,3 if I disabled mulitcast

Thanks very much.
