Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FXNSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab3FXNSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:18:34 -0400
Date: Mon, 24 Jun 2013 15:17:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 0/18] Paravirtualized ticket spinlocks
Message-ID: <20130624131716.GA11948@hawk.usersys.redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:10:14PM +0530, Raghavendra K T wrote:
> 
> Results:
> =======
> base = 3.10-rc2 kernel
> patched = base + this series
> 
> The test was on 32 core (model: Intel(R) Xeon(R) CPU X7560) HT disabled
> with 32 KVM guest vcpu 8GB RAM.

Have you ever tried to get results with HT enabled?

> 
> +-----------+-----------+-----------+------------+-----------+
>                ebizzy (records/sec) higher is better
> +-----------+-----------+-----------+------------+-----------+
>     base        stdev        patched    stdev        %improvement
> +-----------+-----------+-----------+------------+-----------+
> 1x  5574.9000   237.4997    5618.0000    94.0366     0.77311
> 2x  2741.5000   561.3090    3332.0000   102.4738    21.53930
> 3x  2146.2500   216.7718    2302.3333    76.3870     7.27237
> 4x  1663.0000   141.9235    1753.7500    83.5220     5.45701
> +-----------+-----------+-----------+------------+-----------+

This looks good. Are your ebizzy results consistent run to run
though?

> +-----------+-----------+-----------+------------+-----------+
>               dbench  (Throughput) higher is better
> +-----------+-----------+-----------+------------+-----------+
>     base        stdev        patched    stdev        %improvement
> +-----------+-----------+-----------+------------+-----------+
> 1x 14111.5600   754.4525   14645.9900   114.3087     3.78718
> 2x  2481.6270    71.2665    2667.1280    73.8193     7.47498
> 3x  1510.2483    31.8634    1503.8792    36.0777    -0.42173
> 4x  1029.4875    16.9166    1039.7069    43.8840     0.99267
> +-----------+-----------+-----------+------------+-----------+

Hmm, I wonder what 2.5x looks like. Also, the 3% improvement with
no overcommit is interesting. What's happening there? It makes
me wonder what < 1x looks like.

thanks,
drew
