Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3BUTos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:44:48 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:47459 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3BUToq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:44:46 -0500
Message-ID: <512678F9.8020603@synopsys.com>
Date: Fri, 22 Feb 2013 01:13:53 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Chris Zankel <chris@zankel.net>, "Max Filippov" <jcmvbkbc@gmail.com>,
        Marc Gauthier <marc@tensilica.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] memblock: add assertion for zero allocation size
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com> <1361471962-25164-2-git-send-email-vgupta@synopsys.com> <CAE9FiQXSPHjRsCWcHpz7s1gQjNGuj5_X_YE2Ln=EA7_-Ka_cNg@mail.gmail.com> <51267695.8090800@synopsys.com> <20130221193639.GN3570@htj.dyndns.org>
In-Reply-To: <20130221193639.GN3570@htj.dyndns.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 01:06 AM, Tejun Heo wrote:
> On Fri, Feb 22, 2013 at 01:03:41AM +0530, Vineet Gupta wrote:
>> Where - you mean if user passes 0, just make it 1. Nah - it's better to complain
>> and get the call site fixed !
>>
>>> or BUG_ON(!align) instead?
>> That could be done too but you would also need BUG_ON(!size) - to catch another
>> API abuse.
>> BUG_ON(!size) however catches both the cases.
> How about "if (WARN_ON(!align)) align = __alignof__(long long);"?
> Early BUG_ON()s can be painful to debug depending on setup.

Totally agree - been there - seen that :-)
Also for caller passing zero, the panic will force the caller to fix it.
I'll respin the patch.

Thx,
-Vineet

