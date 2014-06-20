Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaFTQPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:15:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaFTQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:15:15 -0400
Message-ID: <53A45E67.7070000@oracle.com>
Date: Fri, 20 Jun 2014 12:16:39 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com> <20140620152312.GB11391@pd.tnic> <53A45627.6090306@oracle.com> <20140620155845.GC11391@pd.tnic>
In-Reply-To: <20140620155845.GC11391@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 11:58 AM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 11:41:27AM -0400, Boris Ostrovsky wrote:
>> Only in the sense that on Xen misc_register() often fails. But any
>> failure on baremetal will result in the same behavior.
> Ok, thanks for explaining the details.
>
>> Right. And I think we shouldn't because we leave undeleted timers.
> I wonder if we could simply move the oneliner:
>
> 	__register_hotcpu_notifier(&mce_cpu_notifier);
>
> to mcheck_init()? We don't need any locking there because we're pre-SMP
> then and from looking at notifier_chain_register(), it seems there's
> nothing special that needs initializing for the call to be too early -
> we're simply adding the callback to a list...
>
> Hmm, because if that would work, the fix is almost trivial. :)

That's cleaner than what I had in mcheck_cpu_init() (checking for 
boot_cpu_data).

But I think you still need to do the dance in the notifier to make sure 
you are not trying to add/remove device if mcheck_init_device() had 
failed earlier.

-boris

