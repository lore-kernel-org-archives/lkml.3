Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaHLHzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:55:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60571 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaHLHzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:55:53 -0400
Date: Tue, 12 Aug 2014 09:55:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, mingo@kernel.org,
        prarit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Message-ID: <20140812075541.GB32061@pd.tnic>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
 <1407828667-14316-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407828667-14316-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:31:06PM +0800, Lan Tianyu wrote:
> With some bad kernel configures, cpu offline consumes more than 100ms
> during S3. This because native_cpu_die() would fall into 100ms
> sleep when cpu idle loop thread marked cpu state to DEAD slower. It's
> timing related issue. What native_cpu_die() does is that poll cpu
> state and wait for 100ms if cpu state hasn't been marked to DEAD.
> The 100ms sleep doesn't make sense. To avoid such long sleep, this
> patch is to add struct completion to each cpu, wait for the completion
> in the native_cpu_die() and wakeup the completion when the cpu state is
> marked to DEAD.
> 
> Tested on the Intel Xeon server with 48 cores, Ivbridge and Haswell laptops.

... and on an AMD laptop.

> the times of cpu offline on these machines are reduced from more than 100ms
> to less than 5ms. The system suspend time reduces 2.3s on the servers.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
