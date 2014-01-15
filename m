Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaAONwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:52:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:61805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaAONwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:52:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="439224207"
Message-ID: <52D69291.8080003@linux.intel.com>
Date: Wed, 15 Jan 2014 05:52:17 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        aravind.gopalakrishnan@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpu, amd: Add workaround for family 16h,
 erratum 793
References: <20140114230711.GS29865@pd.tnic> <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org> <52D5DC51.9010606@zytor.com> <20140115062817.GA11869@gmail.com> <20140115133619.GA32051@pd.tnic>
In-Reply-To: <20140115133619.GA32051@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 05:36 AM, Borislav Petkov wrote:
>>
>> msr_read() would essentially map to rdmsr_safe(). Each method has a
>> return value that can be checked for failure.
> 
> I'm not sure we want to use the _safe() variants by default as it would
> generate the exception tables even in cases where they're clearly not
> needed.
> 

It would be particularly silly if what you end up with is in effect to
wrap msr_read/write() in a BUG_ON(), which is the effect of the current
(trapping) form.  There is something to be said for hard errors.

	-hpa


