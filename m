Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaHHCjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:39:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50318 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbaHHCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:39:35 -0400
Date: Fri, 8 Aug 2014 10:37:34 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Dmitry Popov <ixaphire@qrator.net>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Weird NET_RX softirq behavior
Message-ID: <20140808103734.677bff7e@xhacker>
In-Reply-To: <20140807181813.37b73927513266381d55ad0d@qrator.net>
References: <20140807171050.77819b10@xhacker>
	<20140807181813.37b73927513266381d55ad0d@qrator.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-07_08:2014-08-06,2014-08-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408080026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Thu, 7 Aug 2014 07:18:13 -0700
Dmitry Popov <ixaphire@qrator.net> wrote:

> On Thu, 7 Aug 2014 17:10:50 +0800
> Jisheng Zhang <jszhang@marvell.com> wrote:
> 
> > 2. only one netdev in the system: eth0.
> 
> There should also be lo (loopback) at least.

Yep, I forget that ;)

> 
> > 4. But NET_RX seems abnormal
> > ~ # cat /proc/softirqs 
> >                     CPU0       CPU1       CPU2       CPU3       
> >       NET_RX:     445587        322        983          0
> > 
> > I'm expecting NET_RX under CPU1, 2, 3 should be zero. Any suggestions
> > about this abnormal behavior?
> 
> Do you have any loopback traffic? It could be handled by CPU1/2 explaining
> non-zero NET_RX counters.

Yes. lo only send and recive 7 packets so far, about 1400bytes. Seems small
comparing with the CPU1 and CPU2 NET_RX softirq numbers, right?

Any other possible case?

Thanks for your reply,
Jisheng
