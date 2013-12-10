Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3LJLpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:45:38 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:47450 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3LJLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:45:34 -0500
Date: Tue, 10 Dec 2013 12:45:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131210114530.GB29875@gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
 <1386478624.4748.19.camel@marge.simpson.net>
 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
 <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386652637.5374.72.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> Hi Len,
> 
> I'm unable to reproduce those DL980 results.  I updated the kernel and
> config yesterday, and happened to run turbostat again.. and the box was
> nowhere near as quiet.  I ended up spending all day futzing with the
> darn thing, checking various config/kernel combos, and none produced the
> previous result.
> 
> ATM, running the same exact updated kernel as the x3550 is running
> (still happily) with only a couple needed drivers added:
> 
> vogelweide:~/:[130]# turbostat -P -i 60
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
>              0.02 2.12 2.26   0  43.40  56.57   0.00   53  33.81   0.00
>  0   0   0   0.23 2.10 2.26   5  65.47  34.30   0.00   52  10.69   0.00
>  1   0   8   0.04 2.02 2.26   5  63.10  36.86   0.00   41  13.31   0.00
>  2   0  16   0.04 1.90 2.26   5  35.70  64.25   0.00   43  37.88   0.00
>  3   0  24   0.03 2.08 2.26   5  39.78  60.19   0.00   42  29.00   0.00
>  4   0  32   0.03 1.95 2.26   5  14.64  85.33   0.00   37  65.00   0.00
>  5   0  40   0.03 1.95 2.26   5  15.96  84.02   0.00   36  74.34   0.00
>  6   0  48   0.02 1.99 2.26   5  36.97  63.01   0.00   37  40.20   0.00
>  7   0  56   0.02 2.08 2.26   5  57.54  42.44   0.00   44   0.08   0.00
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
>              0.03 2.08 2.26   0  31.24  68.73   0.00   53  44.26   0.00
>  0   0   0   0.25 1.76 2.26   8  52.96  46.78   0.00   51  31.99   0.00
>  1   0   8   0.03 1.96 2.26   8  50.69  49.28   0.00   41  30.80   0.00
>  2   0  16   0.04 1.91 2.26   8  36.10  63.85   0.00   42  44.37   0.00
>  3   0  24   0.03 1.96 2.26   8  24.15  75.82   0.00   42  59.14   0.00
>  4   0  32   0.03 1.94 2.26   8  14.68  85.29   0.00   37  71.64   0.00
>  5   0  40   0.03 1.94 2.26   8  16.01  83.96   0.00   36  78.62   0.00
>  6   0  48   0.02 2.18 2.26   8  46.79  53.18   0.00   36  11.05   0.00
>  7   0  56   0.02 2.01 2.26   8  50.84  49.14   0.00   45  26.50   0.00
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
>              0.03 2.10 2.26   0  30.88  69.09   0.00   51  48.09   0.00
>  0   0   0   0.23 1.84 2.26   8  51.98  47.79   0.00   50  31.06   0.00
>  1   0   8   0.04 2.05 2.26   8  59.44  40.52   0.00   41  21.86   0.00
>  2   0  16   0.04 1.73 2.26   8  22.87  77.09   0.00   41  62.26   0.00
>  3   0  24   0.03 1.93 2.26   8   9.83  90.14   0.00   41  77.33   0.00
>  4   0  32   0.03 1.90 2.26   8   8.66  91.31   0.00   37  89.16   0.00
>  5   0  40   0.03 2.05 2.26   8  27.30  72.67   0.00   35  50.62   0.00
>  6   0  48   0.02 2.07 2.26   8  44.81  55.17   0.00   36  18.97   0.00
>  7   0  56   0.02 2.00 2.26   8  48.06  51.91   0.00   42  33.44   0.00
> 
> That, vs solid >99% pc3 for old 3.0 enterprise kernel.  What 
> happened, dunno, kernel called itself master.  Whatever, I don't 
> like test bogons, and this is one, so I thought I should let you 
> know.  DL980 refuses to come close to the previous result.
> 
> 'nuff of that, off to the slave pits before yet another day 
> evaporates.

An ftrace function trace of the anomaly would be awfully useful.

(or a trace generated of a dozen strategically placed trace_printk()s 
debug lines tracing the guts of cpuidle.)

Thanks,

	Ingo
