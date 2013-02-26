Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3BZGKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:10:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab3BZGK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:10:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,738,1355068800"; 
   d="scan'208";a="6770109"
Message-ID: <512C51B0.1000605@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 14:09:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Martin Bligh <mbligh@mbligh.org>, Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Don Morris <don.morris@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com> <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com> <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com> <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com> <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com>
In-Reply-To: <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 14:09:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 14:09:36,
	Serialize complete at 2013/02/26 14:09:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 12:51 PM, Martin Bligh wrote:
>> Do you mean we can remove numaq x86 32bit code now?
>
> Wouldn't bother me at all. The machine is from 1995, end of life c. 2000?
> Was useful in the early days of getting NUMA up and running on Linux,
> but is now too old to be a museum piece, really.
>
> M.
>

Hi Martin, Yinghai,

It was me that I failed to make numa_init() fall back path working, and 
forgot
to call early_parse_srat in ia64. Sorry for the breaking of other 
platform. :)

So now, is Yinghai's patch enough for this problem ?
Or we can encapsulate the following clear up work into one function ?

+		for (i = 0; i < MAX_LOCAL_APIC; i++)
+			set_apicid_to_node(i, NUMA_NO_NODE);
+		nodes_clear(numa_nodes_parsed);
+		memset(&numa_meminfo, 0, sizeof(numa_meminfo));


Thanks. :)
