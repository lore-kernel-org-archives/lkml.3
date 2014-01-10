Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaAJOiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:38:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaAJOir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:38:47 -0500
Date: Fri, 10 Jan 2014 14:38:42 +0000
From: Mel Gorman <mgorman@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, athorlton@sgi.com,
        Rik van Riel <riel@redhat.com>, chegu_vinod@hp.com,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140110143842.GC27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
 <20140108134858.GF27046@suse.de>
 <CAJvTdKmR90tsOWgo-2t9neNFTE15SOYtPN7zgjGKDvafWfk0TA@mail.gmail.com>
 <CAJvTdK=vJxYgtLOYZZPrwGNgYQrFVeCq18RwzEfh5n_tZyeP9g@mail.gmail.com>
 <20140110102617.GX27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140110102617.GX27046@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:26:17AM +0000, Mel Gorman wrote:
> > Also, can you try this attached incremental patch to see if it helps?
> 
> I'll fire it up after pushing send on this mail.
> 

Relevant parts of the mmtests config file used

export MMTESTS="ebizzy"
export EBIZZY_MAX_THREADS=$((NUM_CPU*2))
export EBIZZY_DURATION=10
export EBIZZY_ITERATIONS=10

Three kernels tested -- vanilla kernel, fixidle is your patch and revert is a
revert of 40e2d7f9b5dae048789c64672bf3027fbb663ffa

ebizzy
                     3.13.0-rc7            3.13.0-rc7            3.13.0-rc7
                        vanilla          fixidle-v1r1           revert-v1r1
Mean   1      3153.70 (  0.00%)     3271.40 (  3.73%)     3170.40 (  0.53%)
Mean   2      1725.90 (  0.00%)     1714.90 ( -0.64%)     2366.90 ( 37.14%)
Mean   3      1659.70 (  0.00%)     1654.30 ( -0.33%)     2301.10 ( 38.65%)
Mean   4      1636.10 (  0.00%)     1638.20 (  0.13%)     2287.30 ( 39.80%)
Mean   5      1586.90 (  0.00%)     1598.80 (  0.75%)     2312.10 ( 45.70%)
Mean   6      1544.00 (  0.00%)     1555.00 (  0.71%)     2264.00 ( 46.63%)
Mean   7      1543.10 (  0.00%)     1543.70 (  0.04%)     2296.50 ( 48.82%)
Mean   8      1541.70 (  0.00%)     1548.40 (  0.43%)     2284.70 ( 48.19%)
Mean   12     1542.50 (  0.00%)     1550.80 (  0.54%)     2268.20 ( 47.05%)
Mean   16     1543.00 (  0.00%)     1546.10 (  0.20%)     2261.70 ( 46.58%)
Mean   20     1541.60 (  0.00%)     1551.20 (  0.62%)     2262.60 ( 46.77%)
Mean   24     1548.00 (  0.00%)     1546.20 ( -0.12%)     2240.30 ( 44.72%)
Mean   28     1537.00 (  0.00%)     1544.20 (  0.47%)     2172.40 ( 41.34%)
Mean   32     1542.70 (  0.00%)     1552.70 (  0.65%)     2118.80 ( 37.34%)
Mean   36     1538.70 (  0.00%)     1548.80 (  0.66%)     2074.40 ( 34.82%)
Mean   40     1536.40 (  0.00%)     1539.90 (  0.23%)     2041.20 ( 32.86%)
Mean   44     1535.00 (  0.00%)     1542.90 (  0.51%)     2011.60 ( 31.05%)
Mean   48     1534.90 (  0.00%)     1544.00 (  0.59%)     2002.60 ( 30.47%)
Mean   52     1530.40 (  0.00%)     1531.90 (  0.10%)     1994.80 ( 30.35%)
Mean   56     1531.50 (  0.00%)     1527.10 ( -0.29%)     1980.90 ( 29.34%)
Mean   60     1528.90 (  0.00%)     1527.40 ( -0.10%)     1995.60 ( 30.53%)
Mean   64     1527.10 (  0.00%)     1526.50 ( -0.04%)     1985.50 ( 30.02%)
Mean   68     1527.80 (  0.00%)     1522.50 ( -0.35%)     1983.70 ( 29.84%)
Mean   72     1524.50 (  0.00%)     1523.50 ( -0.07%)     1976.70 ( 29.66%)
Mean   76     1520.80 (  0.00%)     1525.20 (  0.29%)     1964.10 ( 29.15%)
Mean   80     1522.30 (  0.00%)     1519.30 ( -0.20%)     1966.20 ( 29.16%)
Mean   84     1522.60 (  0.00%)     1520.00 ( -0.17%)     1948.30 ( 27.96%)
Mean   88     1521.40 (  0.00%)     1521.40 (  0.00%)     1949.00 ( 28.11%)
Mean   92     1515.80 (  0.00%)     1517.10 (  0.09%)     1938.00 ( 27.85%)
Mean   96     1516.00 (  0.00%)     1517.40 (  0.09%)     1930.50 ( 27.34%)

The latest patch makes little difference. Reverting makes a massive
difference. I didn't include the standard deviations but they are very
small and the performance gain from the revert is far outside the noise.

ebizzy Thread spread
                     3.13.0-rc7            3.13.0-rc7            3.13.0-rc7
                        vanilla          fixidle-v1r1           revert-v1r1
Mean   1         0.00 (  0.00%)        0.00 (  0.00%)        0.00 (  0.00%)
Mean   2        39.80 (  0.00%)      203.40 (-411.06%)        0.10 ( 99.75%)
Mean   3        90.90 (  0.00%)       70.10 ( 22.88%)        0.30 ( 99.67%)
Mean   4        83.00 (  0.00%)       79.30 (  4.46%)        0.30 ( 99.64%)
Mean   5        16.20 (  0.00%)       37.90 (-133.95%)        0.40 ( 97.53%)
Mean   6        54.40 (  0.00%)       45.40 ( 16.54%)        0.50 ( 99.08%)
Mean   7        45.90 (  0.00%)       37.90 ( 17.43%)        0.30 ( 99.35%)
Mean   8        36.30 (  0.00%)       43.90 (-20.94%)        0.50 ( 98.62%)
Mean   12       31.80 (  0.00%)       29.80 (  6.29%)        0.60 ( 98.11%)
Mean   16       26.20 (  0.00%)       26.70 ( -1.91%)        0.70 ( 97.33%)
Mean   20       20.70 (  0.00%)       19.00 (  8.21%)        1.00 ( 95.17%)
Mean   24       20.10 (  0.00%)       18.00 ( 10.45%)        1.40 ( 93.03%)
Mean   28       17.50 (  0.00%)       15.80 (  9.71%)        3.50 ( 80.00%)
Mean   32       15.50 (  0.00%)       16.20 ( -4.52%)        4.20 ( 72.90%)
Mean   36       14.60 (  0.00%)       14.60 (  0.00%)        3.80 ( 73.97%)
Mean   40       13.40 (  0.00%)       12.50 (  6.72%)        3.70 ( 72.39%)
Mean   44       12.20 (  0.00%)       13.50 (-10.66%)        3.20 ( 73.77%)
Mean   48       11.80 (  0.00%)       13.00 (-10.17%)        2.70 ( 77.12%)
Mean   52       11.10 (  0.00%)       11.20 ( -0.90%)        2.60 ( 76.58%)
Mean   56       10.00 (  0.00%)       10.50 ( -5.00%)        2.10 ( 79.00%)
Mean   60       10.00 (  0.00%)       10.00 (  0.00%)        2.30 ( 77.00%)
Mean   64        9.30 (  0.00%)        9.30 (  0.00%)        2.60 ( 72.04%)
Mean   68        9.80 (  0.00%)        9.70 (  1.02%)        2.00 ( 79.59%)
Mean   72        9.80 (  0.00%)        9.00 (  8.16%)        2.00 ( 79.59%)
Mean   76        8.80 (  0.00%)        9.60 ( -9.09%)        2.00 ( 77.27%)
Mean   80        8.20 (  0.00%)        8.40 ( -2.44%)        2.00 ( 75.61%)
Mean   84        8.30 (  0.00%)        8.00 (  3.61%)        2.10 ( 74.70%)
Mean   88        8.20 (  0.00%)        7.90 (  3.66%)        2.00 ( 75.61%)
Mean   92        8.40 (  0.00%)        7.50 ( 10.71%)        1.90 ( 77.38%)
Mean   96        8.10 (  0.00%)        7.60 (  6.17%)        2.20 ( 72.84%)

This shows the difference in performance between threads. It's
interesting to note that reverting the patch gives almost equal
performance to each thread

It's worth noting that automatic NUMA balancing is enabled and active
during these tests which would be one large potential difference between
our configs. I do not think it would be enough to explain the large
performance differences though.

-- 
Mel Gorman
SUSE Labs
