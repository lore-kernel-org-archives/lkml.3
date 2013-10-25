Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3JYCWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 22:22:35 -0400
Received: from mouse.start.ca ([64.140.120.56]:49938 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3JYCWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 22:22:34 -0400
Message-ID: <5269D5D1.60103@start.ca>
Date: Thu, 24 Oct 2013 22:22:09 -0400
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*() family
 helpers
References: <cover.1382103786.git.agordeev@redhat.com> <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com> <20131024105158.GB13159@mtj.dyndns.org> <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com> <20131024114133.GA26610@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20131024114133.GA26610@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-10-24 07:41 AM, Alexander Gordeev wrote:
> On Thu, Oct 24, 2013 at 11:57:40AM +0100, David Laight wrote:
>> The one case it doesn't work is where the driver either
>> wants the full number or the minimum number - but not
>> a value in between.
>>
>> Might be worth adding an extra parameter so that this
>> (and maybe other) odd requirements can be met.
> 
> IMHO its not worth it, since it is not possible to generalize
> all odd requirements out there. I do not think we should blow
> the API in this case.
> 
> Having said that, the min-or-max interface is probably the only
> worth considering. But again, I would prefer to put its semantics
> to function name rather than to extra parameters, i.e.
> 
> pcim_enable_msix_min_max(struct pci_dev *dev, struct msix_entry *entries,
> 			 unsigned int minvec, unsigned int maxvec);

The hardware I have in mind here works only for powers of two.
Eg. 16, 8, 4, 2, or 1 MSI-X vector.  Not the odd values in between.

But it appears I can still just use a loop for that case,
calling the new function above instead of the old functions.

Cheers

