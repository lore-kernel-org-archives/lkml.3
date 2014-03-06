Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaCFGvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:51:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42012 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaCFGvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:51:36 -0500
Message-ID: <53181AC1.2020807@zytor.com>
Date: Wed, 05 Mar 2014 22:50:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@cs.technion.ac.il>, WANG Chao <chaowang@redhat.com>
CC: "Jon D. Mason" <jdmason@kudzu.us>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
        discuss@x86-64.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com> <20140305053617.GE26240@dhcp-17-89.nay.redhat.com> <20140306064756.GB16859@needle.mulix.org>
In-Reply-To: <20140306064756.GB16859@needle.mulix.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 10:47 PM, Muli Ben-Yehuda wrote:
> On Wed, Mar 05, 2014 at 01:36:17PM +0800, WANG Chao wrote:
> 
>> Hi, Muli
>>
>> saved_max_pfn is becoming a setback for kexec-tools. Ideally calgary
>> could get rid of saved_max_pfn at all. But If this can't work, how
>> about exporting a calgary tce table size to user space, so that
>> kexec-tools can simply pass calgary=xxx cmdline to 2nd kernel.
> 
> As Jon noted, this code is used to so that the TCE table remains
> consistent between the original and the kexec'd kernel. I see two
> options: either we hard code the TCE table size to the max so that
> this bit of code becomes redundant, or we explicitly pass the original
> table size (or the original max_pfn) to the kexec'd kernel. The first
> option is more appealing, because I don't think anyone is actually
> using the TCE table size -- we mostly added it for debugging the IOMMU
> TCE code at the time -- but since I don't have a Calgary machine
> anymore, I don't have any way to test it. The second option is uglier
> but would be fully backward-compatible and less likely to break
> things. Given that very few people are likely running the latest
> upstream kernel on Calgary/CalIOC2 machines, I'm inclined towards the
> first option.
> 
>> BTW MAINTAINERS file still uses your old email, please update
>> accordingly.
> 
> I think you are the first person to actually look up the Calgary
> maintainers in the last few years :-)
> 

OK, second question... is it time to axe Calgary?

	-hpa


