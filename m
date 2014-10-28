Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbaJ1GBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:01:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:42252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbaJ1GB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407085163"
Message-ID: <544F307D.7090701@intel.com>
Date: Tue, 28 Oct 2014 13:58:21 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-10-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241408360.5308@nanos> <9E0BE1322F2F2246BD820DA9FC397ADE0180ED16@shsmsx102.ccr.corp.intel.com> <alpine.DEB.2.11.1410272135420.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410272135420.5308@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 04:36 AM, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Ren, Qiaowei wrote:
>> On 2014-10-24, Thomas Gleixner wrote:
>>> On Sun, 12 Oct 2014, Qiaowei Ren wrote:
>>>
>>>> This patch sets bound violation fields of siginfo struct in #BR
>>>> exception handler by decoding the user instruction and constructing
>>>> the faulting pointer.
>>>>
>>>> This patch does't use the generic decoder, and implements a limited
>>>> special-purpose decoder to decode MPX instructions, simply because
>>>> the generic decoder is very heavyweight not just in terms of
>>>> performance but in terms of interface -- because it has to.
>>>
>>> My question still stands why using the existing decoder is an issue.
>>> Performance is a complete non issue in case of a bounds violation and
>>> the interface argument is just silly, really.
>>>
>>
>> As hpa said, we only need to decode several mpx instructions
>> including BNDCL/BNDCU, and general decoder looks like a little
>> heavy. Peter, what do you think about it?
>
> You're repeating yourself. Care to read the discussion about this from
> the last round of review again?
>

Ok. I will go through it again. Thanks.

- Qiaowei
