Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab3FTVVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:21:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49039 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab3FTVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:21:34 -0400
Message-ID: <51C37251.4000008@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 02:51:21 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
References: <20130619175438.2852.93449.stgit@localhost.localdomain> <20130619175728.2852.73156.stgit@localhost.localdomain> <20130619180441.GK28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com> <20130619183640.GL28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com> <20130619201438.GM28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com> <20130619210706.GP28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062021-2674-0000-0000-0000098066B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 02:58 AM, Luck, Tony wrote:
>> Ok, where is that semantics? What in a CPER record does say "this error
>> should tell you that you need to offline the containing page and I'm
>> telling you this exactly only once"? Error Severity 0, i.e. Recoverable?
>
> Naveen - this one is for you (or for your BIOS team).  Can you get us a sample
> CPER that you plan to provide when the BIOS decides that its threshold has
> been exceeded?  How will it be different from what old WSM-EX platforms
> were sending to us?  Hopefully the answer is encoded in the CPER record
> and not in some code we have to put in Linux to say "if (IBMplatform) do_thing_1(); else ... "

Looking at the specs, there might be a few ways we can do this:
- One, Error threshold value of 1 in the Hardware Error Notification 
structure of CMC. This field is described as the number of error events 
before OS considers this as an error event. With a threshold value of 1, 
we are essentially asking the OS not to threshold further.
- Two, the Generic Error Data Entry (aka UEFI Section Descriptor) has a 
flag which indicates 'Error Threshold Exceeded'. From the UEFI spec, it 
looks like we could consider this as an indication to offline the page; 
though I am not sure if/how this relates to the threshold value above.

Thoughts?


Thanks,
Naveen

