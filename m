Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3GPGzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:55:04 -0400
Received: from srv01.voixit.com ([78.47.68.188]:47998 "EHLO srv01.voixit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3GPGzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:55:03 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 02:55:02 EDT
Message-ID: <51E4EC51.6000607@unimore.it>
Date: Tue, 16 Jul 2013 08:46:41 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fchecconi@gmail.com, rizzo@iet.unipi.it
Subject: Re: [PATCH BUGFIX] pkt_sched: sch_qfq: remove a source of high packet
 delay/jitter
References: <1373911290-6237-1-git-send-email-paolo.valente@unimore.it> <1373911942.2062.24.camel@joe-AO722>
In-Reply-To: <1373911942.2062.24.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/07/2013 20:12, Joe Perches ha scritto:
> On Mon, 2013-07-15 at 20:01 +0200, Paolo Valente wrote:
>> QFQ+ inherits from QFQ a design choice that may cause a high packet
>> delay/jitter and a severe short-term unfairness.
> []
>> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> []
>> @@ -189,6 +188,7 @@ struct qfq_sched {
>>   	struct qfq_aggregate	*in_serv_agg;   /* Aggregate being served. */
>>   	u32			num_active_agg; /* Num. of active aggregates */
>>   	u32			wsum;		/* weight sum */
>> +	unsigned long		iwsum;		/* inverse weight sum*/
>
> This is a different size for 32/64 bit compiles
> and may be better as u32.
>
>
Sending a new version with u32, thanks.
