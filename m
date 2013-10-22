Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3JVKv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:51:56 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33180 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3JVKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:51:52 -0400
Message-ID: <52664621.8070307@linux.vnet.ibm.com>
Date: Tue, 22 Oct 2013 15:02:17 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
CC: "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86 platform
References: <52657a78162905670f@agluck-desk.sc.intel.com>
In-Reply-To: <52657a78162905670f@agluck-desk.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102210-9574-0000-0000-00000A320CB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 12:33 AM, Luck, Tony wrote:
>> But yes, this is possible and it would make it all even cleaner
>> and simpler by simply not needing the reg/dereg interfaces for
>> mce_ext_err_print but adding it to the chain.
>
> So this is on top of the 9 patch series (using the V4 that Chen Gong
> posted for part 4/9 and V3 for all the others).  Obviously it should
> be folded back into the series if we go this way.
>
> It's a bit simplistic right now - the registered function just returns
> NOTIFY_DONE in all cases so it will not disturb processing by any other
> registered functions - we can make it smarter later.

Looks good. We obviously need to ensure this gets called before EDAC, if 
at all. The other question is w.r.t conflicts with EDAC, which we can 
re-visit as part of the discussions around a new trace event.

Thanks,
Naveen

