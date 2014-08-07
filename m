Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaHGI7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:59:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:7895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbaHGI7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,816,1400050800"; 
   d="scan'208";a="465978644"
Message-ID: <53E33F4D.7080701@intel.com>
Date: Thu, 07 Aug 2014 16:56:45 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com> <20140804102301.GB4808@pd.tnic> <53E04457.2060507@intel.com> <20140805075419.GA18234@pd.tnic> <53E0A3EE.50708@intel.com> <20140806110748.GC27033@pd.tnic> <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com> <20140806160652.GD27033@pd.tnic>
In-Reply-To: <20140806160652.GD27033@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月07日 00:06, Borislav Petkov wrote:
> Hi,
> 
> On Wed, Aug 06, 2014 at 01:13:21PM +0000, Lan, Tianyu wrote:
>> Have you tried my attached kernel config file? When someone reported
>> the issue to me, I also was very hard to reproduce the issue by my
>> own config file. Maybe once 100 tries. But I can reproduced the issue
>> every time with the attached configure file on several my machines and
>> even on server.
> 
> first of all, please do not top-post:
> 
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 

Hi Borislav:

Sorry. I replied on the Windows machines and ignored the format.I will
notice it. Thanks fro reminder.

> Now, it looks like the issue is timing-related, depending on when we're
> going to see CPU_DEAD, before or after the msleep. Thus, if some distro
> config runs more crap on the suspend path and we don't see the CPU_DEAD
> before we sleep for 100ms, then we get to wait at least once and it
> shows in the suspend trace.
> 
> So, using the completion timeout seems like a net improvement for such
> configs and thus for any config.

Yes, that's exact.

-- 
Best regards
Tianyu Lan
