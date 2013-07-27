Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3G0MAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 08:00:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43203 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3G0MAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 08:00:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Jeremy Eder <jeder@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        daniel.lezcano@linaro.org, "Brown, Len" <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: RFC: revert request for cpuidle patches e11538d1 and 69a37bea
Date: Sat, 27 Jul 2013 14:10:44 +0200
Message-ID: <3673963.IpA4v4b2LB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAJvTdKn3LMhcuWqmNjhpaFX1GPrH1LBtDX1tWPWxDsUZSt4WjQ@mail.gmail.com>
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <10589669.3DKeJru7h0@vostro.rjw.lan> <CAJvTdKn3LMhcuWqmNjhpaFX1GPrH1LBtDX1tWPWxDsUZSt4WjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 27, 2013 02:22:53 AM Len Brown wrote:
> >> OK, I'll queue up the reverts as fixes for 3.11-rc4.
> >
> > So, the reverts are on the fixes-next branch of the linux-pm.git tree that you
> > can access at
> >
> > http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=fixes-next
> >
> > However, they are not simple reverts as we've had some non-trivial changes on
> > top of those commits already, so I'd appreciate it a lot if somebody could
> > double check if I didn't break anything in them.
> 
> I've verified that the reverts improve netperf TCP_RR performance.
> 
> Here I've got two Xeon's, slightly different, so I run in both directions.
> Also I run two ways -- Out-of-the-box, plus with cpufreq
> set to max frequency.  The reverts improve all 4 cases:
> 
> JKT → IVT                IVT → JKT
> 
>  3.11.0-rc2        baseline w/o revert                Out of Box
> 
> 20420                19963
> 20658                19915
> 20298                20320
> 
>  3.11.0-rc2        baseline w/o revert                max freq
> 
> 59658                51427
> 59663                51503
> 59416                51343
> 
> 3.11.0-rc2-00002-g74bce39                        Linux-pm “fixes-next” branch
> 
> 3.11.0-rc2-00002-g74bce39                Out of box
> 23227                22056
> 23306                22125
> 23387                40226                40k result saw some 2.2 ghz
> vs 1.2 ghz in other runs
>                 21991
> 
> 3.11.0-rc2-00002-g74bce39                Max-freq
> 67240                57645
> 64880                56764
> 65924                57435
> 
> Tested-by: Len Brown <len.brown@intel.com>

Many thanks Len!

Rafael

