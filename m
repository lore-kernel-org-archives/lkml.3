Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaIKWcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:32:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:54042 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaIKWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,508,1406617200"; 
   d="scan'208";a="601705001"
Message-ID: <5412230A.6090805@intel.com>
Date: Thu, 11 Sep 2014 15:32:42 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409120015030.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 03:18 PM, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Qiaowei Ren wrote:
>> This patch sets bound violation fields of siginfo struct in #BR
>> exception handler by decoding the user instruction and constructing
>> the faulting pointer.
>>
>> This patch does't use the generic decoder, and implements a limited
>> special-purpose decoder to decode MPX instructions, simply because the
>> generic decoder is very heavyweight not just in terms of performance
>> but in terms of interface -- because it has to.
> 
> And why is that an argument to add another special purpose decoder?

Peter asked for it to be done this way specifically:

	https://lkml.org/lkml/2014/6/19/411

