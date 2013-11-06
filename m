Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3KFPAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:00:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab3KFPAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:00:05 -0500
X-IronPort-AV: E=Sophos;i="4.93,647,1378828800"; 
   d="scan'208";a="8963090"
Message-ID: <527A5985.6050309@cn.fujitsu.com>
Date: Wed, 06 Nov 2013 23:00:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] srcu: API for barrier after srcu read unlock
References: <1383592884-2535-1-git-send-email-mst@redhat.com> <20131104205524.GY3947@linux.vnet.ibm.com>
In-Reply-To: <20131104205524.GY3947@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 22:58:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 22:58:07,
	Serialize complete at 2013/11/06 22:58:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 04:55 AM, Paul E. McKenney wrote:
> On Mon, Nov 04, 2013 at 10:36:17PM +0200, Michael S. Tsirkin wrote:
>> srcu read lock/unlock include a full memory barrier
>> but that's an implementation detail.
>> Add an API for make memory fencing explicit for
>> users that need this barrier, to make sure we
>> can change it as needed without breaking all users.
>>
>> Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: "Lai Jiangshan" <laijs@cn.fujitsu.com>

> 
>> ---
>>  include/linux/srcu.h | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
>> index c114614..9b058ee 100644
>> --- a/include/linux/srcu.h
>> +++ b/include/linux/srcu.h
>> @@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>>  	__srcu_read_unlock(sp, idx);
>>  }
>>
>> +/**
>> + * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
>> + *
>> + * Converts the preceding srcu_read_unlock into a two-way memory barrier.
>> + *
>> + * Call this after srcu_read_unlock, to guarantee that all memory operations
>> + * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
>> + * the preceding srcu_read_unlock.
>> + */
>> +static inline void smp_mb__after_srcu_read_unlock(void)
>> +{
>> +	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
>> +}
>> +
>>  #endif
>> -- 
>> MST
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

