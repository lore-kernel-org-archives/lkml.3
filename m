Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3G0GW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 02:22:58 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:33418 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3G0GWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 02:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <10589669.3DKeJru7h0@vostro.rjw.lan>
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
	<51F2C014.90102@redhat.com>
	<1661917.srTpO55z5q@vostro.rjw.lan>
	<10589669.3DKeJru7h0@vostro.rjw.lan>
Date: Sat, 27 Jul 2013 02:22:53 -0400
X-Google-Sender-Auth: MxoIjbBWqC0Lr0sgE3X5FoifFwI
Message-ID: <CAJvTdKn3LMhcuWqmNjhpaFX1GPrH1LBtDX1tWPWxDsUZSt4WjQ@mail.gmail.com>
Subject: Re: RFC: revert request for cpuidle patches e11538d1 and 69a37bea
From: Len Brown <lenb@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>, Jeremy Eder <jeder@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        daniel.lezcano@linaro.org, "Brown, Len" <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> OK, I'll queue up the reverts as fixes for 3.11-rc4.
>
> So, the reverts are on the fixes-next branch of the linux-pm.git tree that you
> can access at
>
> http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=fixes-next
>
> However, they are not simple reverts as we've had some non-trivial changes on
> top of those commits already, so I'd appreciate it a lot if somebody could
> double check if I didn't break anything in them.

I've verified that the reverts improve netperf TCP_RR performance.

Here I've got two Xeon's, slightly different, so I run in both directions.
Also I run two ways -- Out-of-the-box, plus with cpufreq
set to max frequency.  The reverts improve all 4 cases:

JKT → IVT                IVT → JKT

 3.11.0-rc2        baseline w/o revert                Out of Box

20420                19963
20658                19915
20298                20320

 3.11.0-rc2        baseline w/o revert                max freq

59658                51427
59663                51503
59416                51343

3.11.0-rc2-00002-g74bce39                        Linux-pm “fixes-next” branch

3.11.0-rc2-00002-g74bce39                Out of box
23227                22056
23306                22125
23387                40226                40k result saw some 2.2 ghz
vs 1.2 ghz in other runs
                21991

3.11.0-rc2-00002-g74bce39                Max-freq
67240                57645
64880                56764
65924                57435

Tested-by: Len Brown <len.brown@intel.com>

thanks,
Len Brown, Intel Open Source Technology Center
