Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3KVAzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:55:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37919 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVAzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:55:33 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <528EAB73.9010700@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 09:55:15 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/21 2:50), Vivek Goyal wrote:
> Current proposed secureboot implementation disables kexec/kdump because
> it can allow unsigned kernel to run on a secureboot platform. Intial
> idea was to sign /sbin/kexec binary and let that binary do the kernel
> signature verification. I had posted RFC patches for this apparoach
> here.
>
> https://lkml.org/lkml/2013/9/10/560
>
> Later we had discussion at Plumbers and most of the people thought
> that signing and trusting /sbin/kexec is becoming complex. So a
> better idea might be let kernel do the signature verification of
> new kernel being loaded. This calls for implementing a new system call
> and moving lot of user space code in kernel.
>
> kexec_load() system call allows loading a kexec/kdump kernel and jump
> to that kernel at right time. Though a lot of processing is done in
> user space which prepares a list of segments/buffers to be loaded and
> kexec_load() works on that list of segments. It does not know what's
> contained in those segments.
>
> Now a new system call kexec_file_load() is implemented which takes
> kernel fd and initrd fd as parameters. Now kernel should be able
> to verify signature of newly loaded kernel.
>
> This is an early RFC patchset. I have not done signature handling
> part yet. This is more of a minimal patch to show how new system
> call and functionality will look like. Right now it can only handle
> bzImage with 64bit entry point on x86_64. No EFI, no x86_32  or any
> other architecture. Rest of the things can be added slowly as need
> arises. In first iteration, I have tried to address most common use case
> for us.
>
> Any feedback is welcome.
>

So, ultimately on this design direction, user-land kexec command someday
will no longer be used at all? Or is there any feature you will keep in
user-land side?

I think it big change if one component in kdump will disappear.

-- 
Thanks.
HATAYAMA, Daisuke

