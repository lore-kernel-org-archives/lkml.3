Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378AbaGPGz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:55:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28188 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbaGPGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:55:55 -0400
Message-ID: <53C621EE.9010701@oracle.com>
Date: Wed, 16 Jul 2014 14:55:42 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: anish@chelsio.com, apw@canonical.com, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, joe.jin@oracle.com
Subject: Re: [Bug report] Hit false positives bug with script/checkpatch.pl
References: <1405479036-6763-1-git-send-email-ethan.zhao@oracle.com> <1405484432.14773.19.camel@joe-AO725>
In-Reply-To: <1405484432.14773.19.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/7/16 12:20, Joe Perches wrote:
> On Wed, 2014-07-16 at 10:50 +0800, Ethan Zhao wrote:
>> Hi,
>>       I hit a false positives bug when run script/checkpatch.pl to my patch,
>> It reported  errors to following macro definition, but in fact the macro is
>> correct, I couldn't change that macro according to the error message output
>> by script/checkpatch.pl. because of this bug, my patch was rejected by some
>> guy's patchwork.
> You could tell the guy checkpatch isn't always right.
  He doesn't see my patch, because he filters it out for this issue.
>
> You could also change the macro to something like:
>
> #define NETXEN_NIC_STAT(name, m)				\
> {								\
> 	.name = name,						\
> 	.type = m,						\
> 	.sizeof_stat = FIELD_SIZEOF(struct netxen_adapter, m),	\
> 	.stat_offset = offsetof(struct netxen_adapter, m)	\
> }
  This works for me, thanks for your reply.

  Ethan
> and change the uses like:
>
> static const struct netxen_nic_stats netxen_nic_gstrings_stats[] = {
> 	NETXEN_NIC_STAT("xmit called", stats.xmitcalled),
> 	NETXEN_NIC_STAT("xmit_finished", stats.xmitfinished),
>
> etc...
>
>

