Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaGSFqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:46:09 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36335 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaGSFqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:46:07 -0400
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool get_ethtool_stats()
From: Ethan Zhao <ethan.kernel@gmail.com>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
Date: Sat, 19 Jul 2014 13:45:49 +0800
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com> <C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
To: Rajesh Borundia <rajesh.borundia@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 2014年7月19日，上午2:21，Rajesh Borundia <rajesh.borundia@qlogic.com> 写道：

>> -----Original Message-----
>> From: Ethan Zhao [mailto:ethan.zhao@oracle.com]
>> Sent: Friday, July 18, 2014 9:13 AM
>> To: Manish Chopra; Sony Chacko; Rajesh Borundia; netdev
>> Cc: linux-kernel; ethan.kernel@gmail.com; Ethan Zhao
>> Subject: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool
>> get_ethtool_stats()
>> 
>> netxen driver has implemented netxen_nic_get_ethtool_stats() interface,
>> but it doesn't collect stats.rxdropped in driver, so we will get different
>> rx_dropped statistic information while using ifconfig and ethtool.
>> this patch fills stats.rxdropped field with data from net core with
>> dev_get_stats() just as ixgbe driver did for some of its stats.
> 
> I think ethtool stats are adapter specific. Driver does not maintain
> rx_dropped stats and we also don't get it from adapter.  I am not
> sure if ethtool stats should match ifconfig stats as ifconfig also
> adds net core stats to adapter stats.
I held the same point as yours before I read more drivers implementation under
Ethernet dir, in fact there is no specification/convention that ethtool info is adapter
Specific. All information output by ethtool is based on the information name itself,
One fact we want this patch is netxen defined 'rx dropped' field but output nothing.

> 
> If ethtool stats should report same values as ifconfig stats then
> we may also need to fix tx_dropped statistics.
> 
at least, tx dropped output information... 

Thanks,
Ethan
> Thanks,
> Rajesh
