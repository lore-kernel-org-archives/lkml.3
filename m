Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3CRPZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:25:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3CRPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:25:49 -0400
Message-ID: <1363620340.29475.132.camel@edumazet-glaptop>
Subject: Re: sctp: hang in sctp_remaddr_seq_show
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, vyasevich@gmail.com, sri@us.ibm.com,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 08:25:40 -0700
In-Reply-To: <20130318110415.GA9478@hmsreliant.think-freely.org>
References: <51434D78.9030308@oracle.com>
	 <20130318110415.GA9478@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 07:04 -0400, Neil Horman wrote:

> I'm not sure why the process would never get back to the schedule, but looking
> at the sctp_remaddr_seq_show function, I think that we should convert this
> sequence:
> 	sctp_local_bh_disable();
> 	read_lock(&head->lock);
> 	rcu_read_lock();
> 
> to this:
> 	read_lock(&head->lock);
> 	rcu_read_lock_bh();
> 
> Neil

I dont think so.

BH needs to be disabled before read_lock(&head->lock);

or else, write_lock() could deadlock (assuming it can be called from BH)


