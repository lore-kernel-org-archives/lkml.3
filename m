Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbbAMIsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:48:39 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:44280 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbAMIsh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 13 Jan 2015 03:48:37 -0500
Message-Id: <54B4E9F3020000780005427E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 13 Jan 2015 08:48:35 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: your recent tools/include/ adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

considering that tools/include/ gets used by other than just perf, in
particular arch/x86/vdso/vdso2c.c, would you mind clarifying how
"tools: Move bitops.h from tools/perf/util to tools/" adding an
inclusion of asm/hweight.h to linux/bitops.h is supposed to work,
when the only potentially relevant header to be found is
tools/perf/util/include/asm/hweight.h?

Similarly, with "tools: Adopt fls_long and deps" adding 3 stub
headers to tools/include/asm-generic/bitops/ using
"#include <../../../../include/asm-generic/bitops/...>", I can't
see how these headers are to be found when building the above
mentioned utility - I suppose these really were meant to use
quotes instead of angle brackets.

For reference, the breakage was observed on a relatively old
x86 system where linux/elf.h includes asm/elf.h, reaching
linux/bitops.h via asm/system.h and asm/cpufeature.h.

Thanks for any insight/clarification,
Jan

