Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaLJNtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:49:50 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:55973 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbaLJNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:49:49 -0500
Message-ID: <1418219380.3661.36.camel@linaro.org>
Subject: Re: [PATCH v3] ARM: kprobes: Add test cases for stack consuming
 instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, lizefan@huawei.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 10 Dec 2014 13:49:40 +0000
In-Reply-To: <5488483D.1080900@huawei.com>
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>
			 <1418047765-53197-6-git-send-email-wangnan0@huawei.com>
			 <1418143407.3641.47.camel@linaro.org>
		 <1418145071.3641.60.camel@linaro.org> <54880309.3010100@huawei.com>
	 <1418214862.3661.17.camel@linaro.org> <5488483D.1080900@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 21:18 +0800, Wang Nan wrote:
[...]
> Well, I'm just working on a patch which introducing a TEST_INTOFF and disable interrupts
> for "MRS" testcase. Do you think it is inappropriate?

That's what I started to do, implementing in a similar way to
DONT_TEST_IN_ITBLOCK, and thought the same ints off feature could be
used for the stack consuming instructions checks as well.

Then I realised that for the MRS case it's no use turning ints off for a
single iteration of a test, because the next iteration could see
different results, so that would mean turning interrupts off for all
iterations, which we can't do.

Also, the FIQ flag may not be under our control if Linux isn't running
in secure mode, and I was worried that in such cases we could see the
value of the flag change if secure mode code chose to do so. (Though
perhaps non-secure mode will always read FIQ flag as zero in such a
case?)

So in the end I thought the only robust way of writing the tests would
be to ignore the values of the A and F flags.

-- 
Tixy


