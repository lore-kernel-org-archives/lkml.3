Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaF0PLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:11:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31001 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0PLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:11:22 -0400
Message-ID: <53AD89FB.7090609@oracle.com>
Date: Fri, 27 Jun 2014 11:12:59 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86-ml <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 2 RAS fixes for 3.17, refreshed
References: <20140622164603.GA3385@pd.tnic> <20140624132439.GH4439@pd.tnic> <20140624132701.GB28885@laptop.dumpdata.com> <20140627150155.GG23153@pd.tnic>
In-Reply-To: <20140627150155.GG23153@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 11:01 AM, Borislav Petkov wrote:
> On Tue, Jun 24, 2014 at 09:27:01AM -0400, Konrad Rzeszutek Wilk wrote:
>> Isn't that one a regression that was introduced in 3.16?
> Hrrm, BorisO, you said misc_register would often fail in xen, is that
> correct? Because if so, we added the error check to misc_register in
> 3.16 so the mcheck_init_device fix would have to go in now.


Yes, it fails because xen_late_init_mcelog() registers /dev/mcelog and 
(I think) it happens before mcheck_init_device().

In other words, misc_register() expected to fail in mcheck/mce.c on 
(privileged?) PV guests (provided right CONFIG_XEN_* is set).

-boris
