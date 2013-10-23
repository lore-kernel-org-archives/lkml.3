Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab3JWEmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 00:42:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44293 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3JWEmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 00:42:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20131022214129.GB2715@localhost>
	<20131022.180023.1141845387743361648.davem@davemloft.net>
Date: Tue, 22 Oct 2013 21:38:10 -0700
In-Reply-To: <20131022.180023.1141845387743361648.davem@davemloft.net> (David
	Miller's message of "Tue, 22 Oct 2013 18:00:23 -0400 (EDT)")
Message-ID: <87k3h461ql.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX199KVyX5Dv60hNYeJHX3wyuUIedHgWtntQ=
X-SA-Exim-Connect-IP: 8.25.197.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0073]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: -27% netperf TCP_STREAM regression by "tcp_memcontrol: Kill struct tcp_memcontrol"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: fengguang.wu@intel.com
> Date: Tue, 22 Oct 2013 22:41:29 +0100
>
>> We noticed big netperf throughput regressions
>> 
>>     a4fe34bf902b8f709c63      2e685cad57906e19add7  
>> ------------------------  ------------------------  
>>                   707.40       -40.7%       419.60  lkp-nex04/micro/netperf/120s-200%-TCP_STREAM
>>                  2775.60       -23.7%      2116.40  lkp-sb03/micro/netperf/120s-200%-TCP_STREAM
>>                  3483.00       -27.2%      2536.00  TOTAL netperf.Throughput_Mbps
>> 
>> and bisected it to
>> 
>> commit 2e685cad57906e19add7189b5ff49dfb6aaa21d3
>> Author: Eric W. Biederman <ebiederm@xmission.com>
>> Date:   Sat Oct 19 16:26:19 2013 -0700
>> 
>>     tcp_memcontrol: Kill struct tcp_memcontrol
>
> Eric please look into this, I'd rather have a fix to apply than revert your
> work.

Will do I expect some ordering changed, and that changed the cache line
behavior.

If I can't find anything we can revert this one particular patch without
affecting anything else, but it would be nice to keep the data structure
smaller.

Fengguag what would I need to do to reproduce this?

Eric

