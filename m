Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaCFGsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:48:05 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48611 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaCFGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:48:03 -0500
Date: Thu, 6 Mar 2014 08:47:56 +0200
From: Muli Ben-Yehuda <muli@cs.technion.ac.il>
To: WANG Chao <chaowang@redhat.com>
Cc: "Jon D. Mason" <jdmason@kudzu.us>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140306064756.GB16859@needle.mulix.org>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
 <20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:36:17PM +0800, WANG Chao wrote:

> Hi, Muli
> 
> saved_max_pfn is becoming a setback for kexec-tools. Ideally calgary
> could get rid of saved_max_pfn at all. But If this can't work, how
> about exporting a calgary tce table size to user space, so that
> kexec-tools can simply pass calgary=xxx cmdline to 2nd kernel.

As Jon noted, this code is used to so that the TCE table remains
consistent between the original and the kexec'd kernel. I see two
options: either we hard code the TCE table size to the max so that
this bit of code becomes redundant, or we explicitly pass the original
table size (or the original max_pfn) to the kexec'd kernel. The first
option is more appealing, because I don't think anyone is actually
using the TCE table size -- we mostly added it for debugging the IOMMU
TCE code at the time -- but since I don't have a Calgary machine
anymore, I don't have any way to test it. The second option is uglier
but would be fully backward-compatible and less likely to break
things. Given that very few people are likely running the latest
upstream kernel on Calgary/CalIOC2 machines, I'm inclined towards the
first option.

> BTW MAINTAINERS file still uses your old email, please update
> accordingly.

I think you are the first person to actually look up the Calgary
maintainers in the last few years :-)

Cheers,
Muli
