Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJVPhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:37:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbaJVPhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:37:01 -0400
Message-ID: <5447CF05.4070802@zytor.com>
Date: Wed, 22 Oct 2014 08:36:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, konrad.wilk@oracle.com
CC: tianyu.lan@intel.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] xen/smp: Use die_complete completion when
 taking CPU down
References: <1413478046-4987-1-git-send-email-boris.ostrovsky@oracle.com> <5447CE2B.5090101@citrix.com>
In-Reply-To: <5447CE2B.5090101@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 08:32 AM, David Vrabel wrote:
> On 16/10/14 17:47, Boris Ostrovsky wrote:
>> Commit 2ed53c0d6cc9 ("x86/smpboot: Speed up suspend/resume by avoiding
>> 100ms sleep for CPU offline during S3") introduced completions to CPU
>> offlining process. These completions are not initialized on Xen kernels
>> causing a panic in play_dead_common().
>>
>> Move handling of die_complete into common routines to make them
>> available to Xen guests.
>>
>> (Also, while at it, move these routines as well as die_complete under
>> ifdef CONFIG_HOTPLUG_CPU)
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> I can merge this via the Xen tree if that is preferred.
> 

Since it touches non-Xen code I'd rather not.

	-hpa


