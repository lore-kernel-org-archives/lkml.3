Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaJ1K60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:58:26 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:54056 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbaJ1K6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:58:25 -0400
X-Greylist: delayed 63622 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 06:58:24 EDT
Message-ID: <1414493894.1433.1.camel@linaro.org>
Subject: Re: [PATCH v6 0/7] ARM: kprobes: enable OPTPROBES for ARM 32.
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux@arm.linux.org.uk,
        will.deacon@arm.com, dave.long@linaro.org, taras.kondratiuk@linaro.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Li Zefan <lizefan@huawei.com>
Date: Tue, 28 Oct 2014 10:58:14 +0000
In-Reply-To: <1414430259.1430.9.camel@linaro.org>
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
	 <5449A2BB.1020207@hitachi.com> <1414141323.1441.1.camel@linaro.org>
	 <544B7228.9050200@huawei.com> <1414430259.1430.9.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 17:17 +0000, Jon Medhurst (Tixy) wrote:
[...]
> The decode table could possibly incorporate patterns to
> cover instructions types that you split up in PATCH 1, e.g. so we
> might not need separate PROBES_STORE and PROBES_STORE_EXTRA (

Sorry, I got that a bit wrong, the first patch only splits loads and
stores and doesn't create create any new 'extra' instruction types.
However, my comment could still apply to that split between between
loads and stores; for many of them, the difference is just a single bit
that is possibly cheap or free to test in the checkers.

The reason I am thinking along these lines is that each additional enum
value in the instruction types adds an entry into every action and
checker table, as well as expanding the decoding tables to detect them.
So I just want to make sure that we think these additions result in a
net benefit in code size and complexity.

-- 
Tixy

