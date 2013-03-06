Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3CFVFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:05:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:16248 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab3CFVF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:05:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,797,1355126400"; 
   d="scan'208";a="265554584"
Message-ID: <5137AF96.6050003@linux.intel.com>
Date: Wed, 06 Mar 2013 13:05:26 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-5-git-send-email-feng.tang@intel.com> <alpine.LFD.2.02.1303061451340.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303061451340.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:09 AM, Thomas Gleixner wrote:
> 
> This breaks everything which does not have a 64/32bit divide
> instruction. And you can't replace it with do_div() as that would
> impose massive overhead on those architectures in the fast path.
> 

Could we do the same kind of scaling-by-multiplication that we do in
kernel/time.c for this?

	-hpa


