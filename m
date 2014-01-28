Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaA1R6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:58:22 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41171 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaA1R6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:58:21 -0500
Date: Tue, 28 Jan 2014 18:58:04 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
Message-ID: <20140128175804.GA5287@netboy>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
 <20140113175114.GA4271@netboy>
 <52D42D36.1020400@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D42D36.1020400@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested for a regression using the patched kernel with the nohz=off
command line option...

On Mon, Jan 13, 2014 at 10:15:18AM -0800, John Stultz wrote:
> On 01/13/2014 09:51 AM, Richard Cochran wrote:
> >
> > - Linux 3.12.7-nohz-plain-20140106                nohz-plain.log
> > - Linux 3.12.7-nohz-plain-20140106 NOHZ=OFF       periodic-plain.log
> > - Linux 3.12.7-nohz-fix-20140106-00001-gd753140   nohz-fix.log

Regression check:

 - Linux homeboy 3.12.7-nohz-fix-20140106-00001-gd753140 NOHZ=OFF
   nohz-fix-periodic.log

> > The performance in the log files as reflected in the clock offset is
> > summarized in this table. The values are in nanoseconds.
> >
> >  |         | periodic-plain |      nohz-fix |    nohz-plain |
> >  |---------+----------------+---------------+---------------|
> >  | minimum |  -1.599000e+03 | -1.051000e+03 | -5.373700e+04 |
> >  | maximum |  +1.311000e+03 | +1.048000e+03 | +6.389500e+04 |
> >  | mean    |  +9.880240e-02 | -7.747305e+01 | +1.597904e+01 |
> >  | stddev  |  +4.610021e+02 | +3.960978e+02 | +1.491263e+04 |

Comparing the nohz=off case with and without the patch, the three hour
test looks like this.

  |         | periodic-plain | nohz-fix-periodic |
  |---------+----------------+-------------------+
  | minimum |  -1.599000e+03 |     -1.427000e+03 |
  | maximum |  +1.311000e+03 |     +1.279000e+03 |
  | mean    |  +9.880240e-02 |     -2.710778e+01 |
  | stddev  |  +4.610021e+02 |     +3.974372e+02 |

> >    http://linuxptp.sourceforge.net/nohz-fix/current_nohz.png
> >    http://linuxptp.sourceforge.net/nohz-fix/periodic_vs_fix.png

I also made a third graph showing before and after the patch.

    http://linuxptp.sourceforge.net/nohz-fix/nohz_regression.png

> If you do get a chance to look again, I'd also be interested if running
> with nohz=off w/ the fix doesn't show any regression compared to the
> unmodified nohz=off case.

Looks like there is no regression.

Thanks,
Richard


