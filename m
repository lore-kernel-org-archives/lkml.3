Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3IENKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:10:53 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:39851 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IENKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130905124508.GE9696@mudshark.cambridge.arm.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
	<1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
	<20130905124508.GE9696@mudshark.cambridge.arm.com>
Date: Thu, 5 Sep 2013 15:10:51 +0200
Message-ID: <CAKv+Gu9ro-_LcxdxEg1wsAXzUeWqwbnqGd+nH-toe7hn-9iKMA@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2013 14:45, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> [adding Michael, since I know he was interested in this]
>
> On Wed, Sep 04, 2013 at 07:04:14PM +0100, Jean Pihet wrote:
>> On ARM the debug info is not present in the .eh_frame sections but
>> instead in .debug_frame.
>> Use libunwind to load and parse the debug info.
>
> How have you tested this? Regardless of whether or not I apply this patch, I
> get the same (broken/truncated) callchains for userspace in perf report.

Same here: I have applied these patches against 3.11 running on a
Calxeda Highbank, and I never get more than a single entry for the
userland part of the call stack.

>
> E.g. the following stupid program (built with -O0 -g):
>
[...]
>
> Gives me an incomplete callchain:
>
> # Overhead   Command      Shared Object                           Symbol
> # ........  ........  .................  ...............................
> #
>      0.00%  unwindme  unwindme           [.] bar
>             |
>             --- bar
>

I get exactly the same results, just bar and nothing below.

-- 
Ard.
