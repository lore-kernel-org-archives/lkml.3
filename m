Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3LDBhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:37:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50525 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab3LDBhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:37:00 -0500
Message-ID: <529E8719.4070202@zytor.com>
Date: Tue, 03 Dec 2013 17:36:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Regression due to 0c44c2d0f459 x86: Use asm goto to implement better
 modify_and_test() functions
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

0c44c2d0f459 x86: Use asm goto to implement better modify_and_test()
functions

causes a regression, because it incorrectly changed the constraints of
bitops.

Specifically, the GEN_BINARY_RMWcc() hardcodes a constraint as "er", but
it needs to be "Ir" for the bitops themselves.  "I" is correct (as
opposed to "J" even on 64 bits, because we only generate the 64-bit
version when we have a register operand.

Unfortunately there isn't a way we can get gcc+gas to generate a version
with an offset pointer.

	-hpa


