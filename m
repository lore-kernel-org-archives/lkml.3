Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3ETPIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:08:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54455 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3ETPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:08:12 -0400
Date: Mon, 20 May 2013 17:08:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule, round 2
Message-ID: <20130520150809.GG12690@pd.tnic>
References: <20130520064727.GD12690@pd.tnic>
 <5199C990.3020602@linux.vnet.ibm.com>
 <5199CB59.1020309@linux.vnet.ibm.com>
 <CAKohponk-FQpHOx407FL63ZCYVgz2C-ScvZQBQFVxddbL+fS=A@mail.gmail.com>
 <5199CFD0.9030101@linux.vnet.ibm.com>
 <5199E54D.7030407@linux.vnet.ibm.com>
 <CAKohponS+tCkZyVpDO9fEMQCfsn5h=N235sj5sBGUkD2qKY=cQ@mail.gmail.com>
 <5199EBB5.7060209@linux.vnet.ibm.com>
 <20130520132355.GF12690@pd.tnic>
 <CAKohpokEdnmR4wsAqZgxnLOd5MAn6RNEFYwJQ8Xv1EdRbX1tkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpokEdnmR4wsAqZgxnLOd5MAn6RNEFYwJQ8Xv1EdRbX1tkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 07:13:08PM +0530, Viresh Kumar wrote:
> Hmm, so for sure there is some locking issue there. ave you tried my
> Hpatch?

No, not yet. Pretty busy ATM. Btw, you could try reproducing it too, in
the meantime - simply enable

CONFIG_NO_HZ_COMMON=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ_FULL_ALL=y
CONFIG_NO_HZ=y
CONFIG_RCU_FAST_NO_HZ=y

and halt the box. I don't know whether !x86 boxen support NO_HZ_FULL yet
though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
