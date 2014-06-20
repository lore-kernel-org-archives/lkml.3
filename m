Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967089AbaFTUPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:15:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40118 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbaFTUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:15:33 -0400
Message-ID: <53A496B2.2090701@oracle.com>
Date: Fri, 20 Jun 2014 16:16:50 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com> <20140620152312.GB11391@pd.tnic> <53A45627.6090306@oracle.com> <20140620155845.GC11391@pd.tnic> <53A45E67.7070000@oracle.com> <20140620175240.GE11391@pd.tnic> <53A48DF6.9020503@oracle.com> <20140620200358.GK11391@pd.tnic>
In-Reply-To: <20140620200358.GK11391@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 04:03 PM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 03:39:34PM -0400, Boris Ostrovsky wrote:
>> What about mce_device_add()?
> What is a mce_device_add()? There's no such function.
>


Sorry, mce_device_create().

We can't call it in the notifier until mcheck_init_device() has been 
successfully executed (we need subsys_system_register(&mce_subsys)). I 
don't know whether we can call subsys_system_register() in mcheck_init() 
-- it is quite early in the boot.

-boris
