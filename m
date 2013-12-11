Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3LKWeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:34:31 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33728 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKWea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:34:30 -0500
Date: Wed, 11 Dec 2013 14:34:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nikolay Ulyanitsky <lystor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.10.22+][3.12][performance regression] - huge softirq increase
 on netfilter
Message-ID: <20131211223426.GV4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+Mediw7p6CEHAvP0p=MdCQmWL10QASVpxTo-_WDsvFgxziyww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+Mediw7p6CEHAvP0p=MdCQmWL10QASVpxTo-_WDsvFgxziyww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121122-0928-0000-0000-000004930705
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 02:01:29PM +0200, Nikolay Ulyanitsky wrote:
> Hello
> 
> 
> 3.10.22 has new 2 patches that increase softirq from 0.0% to 15.0% in
> comparison with 3.10.21 on my software routers:
> 
> 78ab8cb      netfilter: nf_conntrack: use RCU safe kfree for conntrack
> extensions

This one fixes a use-after-free bug, so reverting it might be unwise.
However, it looks like it should only be affecting networking connection
tracking.  Is that an important part of your workload?

Also, are you checking overall CPU consumption?  One effect of this
patch is to shift overhead from process level to softirq, so please check
process-level CPU consumption to make sure you have a fair comparison.

> 873be93      ipc/sem.c: synchronize semop and semctl with IPC_RMID

This one also fixes some bugs.  But I don't immediately see why it
should increase softirq CPU consumption.

						Thanx, Paul

> Screenshots:
> Server1 (ipt_NETFLOW):     http://s12.postimg.org/5eprc03tp/vega.png
> Server2 (NAT):    http://s27.postimg.org/swj3he8dv/mimosa.png
> 
> 
> Server1:
> 3.10.21: softirq = 0%
> 3.10.22+, 3.12.4: softirq = 15%
> 3.10.22+, 3.12.4 WITHOUT 78ab8cb, WITH 873be93: softirq = 1%
> 3.10.22+, 3.12.4 WITHOUT 78ab8cb, WITHOUT 873be93: softirq = 0%
> 
> 
> Hardware:
> 2 x Xeon 3.2GHz, Intel SE7520, 4 x Intel 82576 Gigabit Network
> 
> CentOS 6.5 x86_64
> 
> 
> Kernel configs:
> 3.12.4: http://pastebin.com/ugTWFeJg
> 3.10.22: http://pastebin.com/N8z4UAV5
> 
> 
> Please fix/revert these patches.
> 
> 
> Thanks
> 
> 
> –
> 
> With best regards,
> 
> Nikolay Ulyanitsky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

