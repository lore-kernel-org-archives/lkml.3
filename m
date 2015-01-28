Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbA2G0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:26:24 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49197 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbA2G0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:26:22 -0500
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mpe@ellerman.id.au
Cc: rafael.j.wysocki@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH V2] cpuidle/powernv: Read target_residency value of idle states from DT if available
In-Reply-To: <20150128021044.11166.81418.stgit@preeti.in.ibm.com>
References: <20150128021044.11166.81418.stgit@preeti.in.ibm.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-redhat-linux-gnu)
Date: Wed, 28 Jan 2015 20:15:28 +1100
Message-ID: <m3wq47w9jj.fsf@oc8180480414.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012809-0033-0000-0000-0000037B0238
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preeti U Murthy <preeti@linux.vnet.ibm.com> writes:
> The device tree now exposes the residency values for different idle states. Read
> these values instead of calculating residency from the latency values. The values
> exposed in the DT are validated for optimal power efficiency. However to maintain
> compatibility with the older firmware code which does not expose residency
> values, use default values as a fallback mechanism. While at it, handle some
> cleanups.

>From a "I just merged the patch that exports these values from firmware"
point of view, using them and falling back looks good.

(I find the hardcoding of snooze in the driver a bit odd, as is the
hardcoding of max power states to 8 - which could bite us in the future
if a future processor has more states... but these aren't problems with
this patch)

Acked-by: Stewart Smith <stewart@linux.vnet.ibm.com>

