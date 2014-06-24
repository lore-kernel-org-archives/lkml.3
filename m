Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaFXByc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:54:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:62543 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaFXByb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,534,1400050800"; 
   d="scan'208";a="562210976"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 04/10] x86, mpx: hook #BR exception handler to
 allocate bound tables
Thread-Topic: [PATCH v6 04/10] x86, mpx: hook #BR exception handler to
 allocate bound tables
Thread-Index: AQHPitp1GK5+vOkvwEyRhjxb8GKmZpt+niYAgADni8A=
Date: Tue, 24 Jun 2014 01:53:18 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016AF270@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-5-git-send-email-qiaowei.ren@intel.com>
 <53A88606.2050108@mit.edu>
In-Reply-To: <53A88606.2050108@mit.edu>
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

On 2014-06-24, Andy Lutomirski wrote:
> On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
>> +	/*
>> +	 * The error code field of the BNDSTATUS register communicates status
>> +	 * information of a bound range exception #BR or operation involving
>> +	 * bound directory.
>> +	 */
>> +	switch (status & MPX_BNDSTA_ERROR_CODE) {
>> +	case 2:
>> +		/*
>> +		 * Bound directory has invalid entry.
>> +		 * No signal will be sent to the user space.
> 
> This comment is a lie.
> 
Hmm, thanks. 

>> +		 */
>> +		if (do_mpx_bt_fault(xsave_buf))
>> +			force_sig(SIGBUS, tsk);
> 
> Would it make sense to assign and use a new si_code value here?
> 
There is a new si_code SEGV_BNDERR for bounds violation reported by MPX. But in this case, it is mainly due to the failure caused by allocation of bounds table. I guess it is not necessary to add another new si_code value.

Thanks,
Qiaowei
