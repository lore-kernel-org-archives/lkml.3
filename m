Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3IQCmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:42:19 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54994 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751489Ab3IQCmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:42:14 -0400
Message-ID: <5237C183.7040308@hurleysoftware.com>
Date: Mon, 16 Sep 2013 22:42:11 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
References: <20130913005133.GA32479@localhost> <20130913031700.GB23757@kroah.com> <20130913033803.GB8704@localhost>
In-Reply-To: <20130913033803.GB8704@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:38 PM, Fengguang Wu wrote:
> On Thu, Sep 12, 2013 at 08:17:00PM -0700, Greg KH wrote:
>> On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
>>> Hi Peter,
>>>
>>> FYI, we noticed much increased vmap_area_lock contentions since this
>>> commit:
>>
>> What does that mean?  What is happening, are we allocating/removing more
>> memory now?
>
> // leave this question to Peter and Tejun. :)
>
>> What type of load were you running that showed this problem?
>
> The increased contentions and lock hold/wait time showed up in a
> number of test cases.

How is the raw data acquired?

For example, is the test apparatus reading from /proc/vmallocinfo
(which claims the vmap_area_lock) during the test execution?

I'm wondering if a Heisenberg effect is happening here.

Regards,
Peter Hurley


> The second email has the details, and this section of data is most
> illustrating.
>
>      8cb06c983822103da1cf      20bafb3d23d108bc0a89
> ------------------------  ------------------------
>                   3470.31     +1631.0%     60070.49  fat/micro/dd-write/1HDD-cfq-ext4-10dd
>                   3339.57     +1676.9%     59340.71  fat/micro/dd-write/1HDD-cfq-ext4-1dd
>                   2848.79     +1489.1%     45269.54  lkp-a04/micro/netperf/120s-200%-TCP_CRR
>                   3563.01     +1515.2%     57548.50  lkp-a04/micro/netperf/120s-200%-TCP_MAERTS
>                   2678.64     +1346.0%     38733.80  lkp-a04/micro/netperf/120s-200%-TCP_RR
>                   2839.84     +1450.2%     44022.08  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
>                   3417.37     +1571.4%     57116.34  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
>                   2558.59     +1450.8%     39677.58  lkp-a04/micro/netperf/120s-200%-UDP_RR
>                   3737.24     +1558.0%     61963.62  lkp-a04/micro/netperf/120s-200%-UDP_STREAM
>                  20219.50     +1488.7%    321218.02  lkp-a06/crypto/tcrypt/2s-200-204
>                  21017.17     +1457.1%    327257.41  lkp-a06/crypto/tcrypt/2s-205-210
>                  22109.84     +1240.3%    296346.33  lkp-a06/crypto/tcrypt/2s-401-417
>                  17909.60     +1467.3%    280693.71  lkp-a06/micro/dbench/100%
>                 489739.50      +978.5%   5281916.05  lkp-ne04/micro/aim7/shell_rtns_1
>                1601675.63      +906.7%  16123642.52  lkp-snb01/micro/aim7/exec_test
>                  12105.00     +2453.6%    309110.42  nhm-white/micro/aim7/dbase
>                 822461.02     +1585.0%  13858430.62  nhm-white/micro/aim7/exec_test
>                   9858.11     +2715.9%    277595.41  nhm-white/micro/aim7/fork_test
>                   3452.91     +1685.5%     61650.74  nhm-white/micro/aim7/fserver
>                    300.14     +2621.5%      8168.53  nhm-white/micro/aim7/misc_rtns_1
>                 345479.21     +1624.5%   5957828.25  nhm-white/micro/aim7/shell_rtns_1
>                   2694.48     +1974.4%     55894.19  nhm-white/sysbench/oltp/100%-600-1000000
>                   4415.67     +1202.2%     57501.52  nhm8/micro/dbench/100%
>                   2284.65     +1505.2%     36672.75  snb-drag/crypto/tcrypt/2s-200-204
>                   2446.02     +1537.1%     40042.87  snb-drag/crypto/tcrypt/2s-205-210
>                   2484.11     +1599.6%     42219.71  snb-drag/crypto/tcrypt/2s-500-504
>                   2118.55     +1155.8%     26604.99  vpx/crypto/tcrypt/2s-200-204
>                   2713.48     +1198.5%     35234.77  vpx/crypto/tcrypt/2s-205-210
>                   2711.31      +973.8%     29114.07  vpx/crypto/tcrypt/2s-301-319
>                   2369.23      +940.3%     24648.12  vpx/crypto/tcrypt/2s-401-417
>                   2620.64     +1428.7%     40060.71  vpx/crypto/tcrypt/2s-500-504
>                   1713.98     +1624.3%     29553.72  vpx/crypto/tcrypt/2s-505-509
>                3423353.12     +1184.9%  43985148.08  TOTAL lock_stat.vmap_area_lock.holdtime-total
>
> The format of report is
>
>             parent commit                    commit
> ------------------------  ------------------------
>                    number   %change          number     testbox/testcase/test-params
>                    ...
>                    ...
>                    ...
>              total number   %change    total number TOTAL perf-metric-name being compared
>
> Thanks,
> Fengguang
>

