Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaLBO4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:56:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaLBO4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:56:07 -0500
Date: Tue, 2 Dec 2014 15:56:02 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Baoquan He <baoquan.he@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 0/3] Fix kdump failures with crashkernel=high
Message-ID: <20141202145602.GK3156@suse.de>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <547DA2C1.30902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DA2C1.30902@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:30:09PM +0800, Baoquan He wrote:
> The default low memory is calculated in swiotlb_size_or_default(), and
> this relies on IO_TLB_DEFAULT_SIZE which is default value for swiotlb.
> If this doesn't work for your case in kdump kernel, does the default
> value IO_TLB_DEFAULT_SIZE work for swiotlb in 1st kenrel? If not, user
> knows it and should know it will fail for kdump kernel either with
> default vaule, user can specify that by crashkernel=x,low which is why
> it's introduced.

In the first kernel the defaults work fine because it has plenty of
low-memory (below 4GB) to allocate from. But in the kdump kernel there
are only 72MB by default, which showed to not be enough to reliably boot
with certain hardware in the machine.

> It may not be a good idea to increase the default low value from 72M to
> 256M. After all the case you are encountering is a special case, special
> case need be treated specially, namely specify it in crashkernel=x,low
> clearly.

I think the kernel should set sane defaults if possible. But to not
increase memory usage for kdump too much, how about subtracting the
amount of low-memory allocated for kdump from the high-mem amount? This
would not increase the overall memory usage.


	Joerg

