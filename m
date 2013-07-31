Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3GaKGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:06:47 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42935 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469Ab3GaKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:06:45 -0400
Message-ID: <51F8E1AD.4070708@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 15:36:37 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when parsing
 'UC' errors.
References: <20130724061626.GA18995@gchen.bj.intel.com> <20130725103647.5009.92648.stgit@localhost.localdomain> <3908561D78D1C84285E8C5FCA982C28F31C9F32B@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C9F32B@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073109-5490-0000-0000-000003EA26DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:31 PM, Luck, Tony wrote:
> 	MCESEV(
> +		PANIC, "Action required but kernel thread is not continuable",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
> +		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV|MCG_STATUS_EIPV),
> +		KERNEL
> +		),
> +	MCESEV(
>   		AR, "Action required: data load error in a user process",
>   		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
>   		USER
>
> This just gives us a better panic message. Right?  Without this we'd keep walking the
> severity table until we hit the "Action required: unknown MCACOD" entry which will
> match and force a panic anyway.

Yes, that's correct. But I felt it would be good to have this entry to 
make it explicit.

>
> So I might look for better wording.  As far as the h/w is concerned the thread is continuable.
> Linux is just not smart enough (yet) to take the required recovery action.

Ok, how about: "Action required but unable to recover kernel thread"


Thanks,
Naveen

