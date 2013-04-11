Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3DKHQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:16:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:21590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3DKHQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,454,1363158000"; 
   d="scan'208";a="293332827"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH v2] x86: add a new SMP bring up way for tboot case
Thread-Topic: [PATCH v2] x86: add a new SMP bring up way for tboot case
Thread-Index: AQHNp1ZNt+1D184rVk2ifbPrsQdETJiu0mBQ//+HiACAI1rtwA==
Date: Thu, 11 Apr 2013 07:16:38 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE507CDA@SHSMSX102.ccr.corp.intel.com>
References: <1349950267-28328-1-git-send-email-qiaowei.ren@intel.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE4E0171@SHSMSX102.ccr.corp.intel.com>
 <514926C0.3020502@zytor.com>
In-Reply-To: <514926C0.3020502@zytor.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Wednesday, March 20, 2013 11:02 AM
> To: Ren, Qiaowei
> Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Maliszewski, Richard L;
> linux-kernel@vger.kernel.org; tboot-devel@lists.sourceforge.net; Xiaoyan
> Zhang; Wei, Gang
> Subject: Re: [PATCH v2] x86: add a new SMP bring up way for tboot case
> 
> On 03/19/2013 07:14 PM, Ren, Qiaowei wrote:
> > Any comments on this patch?
> >
> > Thanks,
> > Qiaowei
> 
> The biggest question is probably if we can use an existing hook of some sort.
> 
> Overriding the apic method is probably not the right way to go, though.
>  tglx, do you have any opinions here?
> 

If we can't use an existing hook, could you please give me any suggestion about other opinions here?

> Furthermore, this really is not nice:
>
> > +int tboot_wake_up(int apicid, unsigned long sipi_vec) {
> > +	if (!tboot_enabled())
> > +		return 0;
> > +
> > +	if ((tboot->version < 6) ||
> > +	    !(tboot->flags & TB_FLAG_AP_WAKE_SUPPORT))
> > +		return 0;
> > +
> > +	tboot->ap_wake_addr = sipi_vec;
> > +	tboot->ap_wake_trigger = apicid;
> > +
> > +	return 1;
> > +}
> 
> Not only don't you set boot_error for the code above it, but there is absolutely
> no indication how that does its job (are those active operations?  If so they
> should use writel()), nor does it include any kind of synchronization.
> 

Ok. I should add some comments to explain how that does its job. 
But I guess boot_error don't have to be set inside this function.

Thanks,
Qiaowei

