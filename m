Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaIDOn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:43:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9430 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaIDOn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:43:57 -0400
X-IronPort-AV: E=Sophos;i="5.04,466,1406592000"; 
   d="scan'208";a="168364048"
Message-ID: <54087AA1.8010208@citrix.com>
Date: Thu, 4 Sep 2014 15:43:45 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>, <xen-devel@lists.xensource.com>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        Juergen Gross <JGross@suse.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: eliminate scalability issues from
 initial mapping setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-4-git-send-email-jgross@suse.com> <54086244.7020601@citrix.com> <540862FE.7070108@citrix.com> <540893F00200007800030E4F@mail.emea.novell.com>
In-Reply-To: <540893F00200007800030E4F@mail.emea.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 15:31, Jan Beulich wrote:
>>>> On 04.09.14 at 15:02, <andrew.cooper3@citrix.com> wrote:
>> On 04/09/14 13:59, David Vrabel wrote:
>>> On 04/09/14 13:38, Juergen Gross wrote:
>>>> Direct Xen to place the initial P->M table outside of the initial
>>>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>>>> restriction on the size of the initial mapping limits the amount
>>>> of memory a domain can be handed initially.
>>> The three level p2m limits memory to 512 GiB on x86-64 but this patch
>>> doesn't seem to address this limit and thus seems a bit useless to me.
>> Any increase of the p2m beyond 3 levels will need to come with
>> substantial libxc changes first.  3 level p2ms are hard coded throughout
>> all the PV build and migrate code.
> No, there no such dependency - the kernel could use 4 levels at
> any time (sacrificing being able to get migrated), making sure it
> only exposes the 3 levels hanging off the fourth level (or not
> exposing this information at all) to external entities making this
> wrong assumption.
>
> Jan
>

That would require that the PV kernel must start with a 3 level p2m and
fudge things afterwards.

At a minimum, I would expect a patch to libxc to detect a 4 level PV
guest and fail with a meaningful error, rather than an obscure "m2p
doesn't match p2m for mfn/pfn X".

~Andrew
