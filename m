Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3KSPzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:55:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:35388 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3KSPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:55:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,729,1378857600"; 
   d="scan'208";a="75990518"
Message-ID: <528B89DA.2080504@citrix.com>
Date: Tue, 19 Nov 2013 15:55:06 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Elena Ufimtseva <ufimtseva@gmail.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <akpm@linux-foundation.org>,
        <tangchen@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 2/2] xen: enable vnuma for PV guest
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com> <1384811922-14642-3-git-send-email-ufimtseva@gmail.com> <528B5160.5010902@citrix.com> <20131119141620.GD5332@phenom.dumpdata.com> <528B774F.7090902@citrix.com> <20131119144630.GA5780@phenom.dumpdata.com> <528B7C29.3050103@citrix.com> <20131119151924.GC5790@phenom.dumpdata.com>
In-Reply-To: <20131119151924.GC5790@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/13 15:19, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 19, 2013 at 02:56:41PM +0000, David Vrabel wrote:
>> The relevant bits in dummy_numa_init are in the error path of
>> xen_numa_init().
> 
> That seems the wrong place to do it. The top layer calls 
> in each of the numa implementations and then falls back to
> the dummy.

Think of it as not the dummy, but Xen setting the NUMA configuration up
with only a single node.

The useful bits in dummy_numa_init() are two calls to standard functions
for use by *_numa_init() calls so it just seems easier all round to just
call then directly than add a dependancy on dummy_numa_init().

> Calling from within the implementation on something that is eventually
> done on the upper level already is not right.

>From the point of view of the caller, it does the right thing.  NUMA is
setup.

>> I do think this approach (using the provided API to setup the single
>> (dummy) node), is preferable to calling dummy_numa_init().
> 
> Doesn't it do the same thing? And also what about if you the user
> provides fakenuma?

I don't know what "fakenuma" is refering to.

>> If I thought the hypervisor ABI was finalized, I'd be happy with this
>> series as-is -- the remaining issues are superficial.
> 
> That reads to me as an Ack, but I know you like to have it stated
> explicitly - so could you state the proper tag please?

"If I thought the hypervisor ABI was finalized..." is a pretty big "if"
so I have deliberately /not/ given an ack or a reviewed tag but I've
tried to be clear than I think the Linux side is now good enough (except
for any changes for any updates to the hypervisor ABI).

David
