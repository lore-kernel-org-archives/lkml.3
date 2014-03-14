Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaCNJ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:57:55 -0400
Received: from numascale.com ([213.162.240.84]:50715 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbaCNJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:57:52 -0400
Message-ID: <5322D295.5080905@numascale.com>
Date: Fri, 14 Mar 2014 17:57:41 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <20140314090617.GA4697@pd.tnic>
In-Reply-To: <20140314090617.GA4697@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 14/03/2014 17:06, Borislav Petkov wrote:
> On Thu, Mar 13, 2014 at 07:43:01PM +0800, Daniel J Blueman wrote:
>> For systems with multiple servers and routed fabric, all northbridges get
>> assigned to the first server. Fix this by also using the node reported from
>> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
>> by definition, which are on NUMA node 0 by definition, so this is invarient
>> on most systems.
>
> Yeah, I think this is of very low risk for !Numascale setups. :-) So
>
> Acked-by: Borislav Petkov <bp@suse.de>
>
>> Tested on fam10h and fam15h single and multi-fabric systems and candidate
>> for stable.
>
> I'm not sure about it - this is only reporting the wrong node, right?
> Does anything depend on that node setting being correct and breaks due
> to this?

It's only reporting the wrong node, yes. The irqbalance daemon uses 
/sys/devices/.../numa_node, and we found we have to disable it to 
prevent hangs on certain systems after a while, but I didn't establish a 
link just yet, though found this to be incorrect.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
