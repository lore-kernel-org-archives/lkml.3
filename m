Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbaDIPfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:35:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaDIPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:35:08 -0400
Message-ID: <5345695A.3020303@oracle.com>
Date: Wed, 09 Apr 2014 11:38:02 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 32-bit PV guests's usage of
 kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com> <5345739202000078000073EA@nat28.tlf.novell.com> <53455933.2060406@citrix.com> <53455C21.6000408@citrix.com> <53457CDD0200007800007483@nat28.tlf.novell.com>
In-Reply-To: <53457CDD0200007800007483@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 11:01 AM, Jan Beulich wrote:
>>>> On 09.04.14 at 16:41, <andrew.cooper3@citrix.com> wrote:
>> The latter load however can easy fault; The arguments for %ds in
>> XSA-42/ CVE-2013-0228 applies to %{e,f,g}s as well.
> And it was only that latter operation that I pointed at.

We don't seem to reference %fs after the pop so doing the fixup (as 
David suggested) should be enough?

-boris


>
>> Furthermore, I am a little concerned about the performance impact of
>> this.  I would have thought that in most cases, %fs will already be
>> correct, at which point reloading it twice is a waste of time.
> Why would you expect %fs on the IRET path to commonly point to the
> kernel segment rather than whatever user mode wants/needs? Also, I'm
> not sure adding conditionals here wouldn't harm performance about as
> much as the save/load/restore. If anything I'd look into open coding
> GET_THREAD_INFO() without using %fs for this single case.
>
> Jan
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

