Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3BZHaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:30:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3BZHaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:30:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,739,1355068800"; 
   d="scan'208";a="6770921"
Message-ID: <512C6462.3030602@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 15:29:38 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
        Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com> <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com> <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com> <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com> <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com> <512C51B0.1000605@cn.fujitsu.com> <CAE9FiQVsmt4jhR=+Uyg+Cbh2AEF9-gAdoPiJrM8itaLCsAOKcA@mail.gmail.com>
In-Reply-To: <CAE9FiQVsmt4jhR=+Uyg+Cbh2AEF9-gAdoPiJrM8itaLCsAOKcA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 15:29:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 15:29:21,
	Serialize complete at 2013/02/26 15:29:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 02:57 PM, Yinghai Lu wrote:
> That is temporary workaround and your patch and this workaround make
> x86 acpi numa init too messy.
>
> I don't see the point to hack SRAT to make memory hotplug working.
>
> Do you guys check and use PMTT in ACPI spec instead?

Hi Yinghai,

Thanks for the suggestion. :)

The point we are using SRAT is that we need the hot-pluggable bit in SRAT.
I didn't find such info in PMTT or elsewhere.

We use SRAT in this way aims to satisfy users who don't want to specify
physical address ranges in kernel command line. They want to use SRAT to
determine which memory is hot-pluggable, and which is not.

To achieve this aim, we have to ensure we have the SRAT info before 
memblock
starts to allocate memory. So that we can prevent memblock from allocating
memory in the hot-pluggable area. So I have to parse SRAT earlier.

I don't think the code is that messy. I think we can encapsulate the clear
up job into one function, and call it where it is needed.

How do you think ?

Thanks. :)
