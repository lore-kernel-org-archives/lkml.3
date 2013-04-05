Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161920Ab3DEO5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:57:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51626 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161881Ab3DEO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:57:15 -0400
Message-ID: <515EE63A.6050307@cip.cs.fau.de>
Date: Fri, 05 Apr 2013 16:56:58 +0200
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] Add non-zero module sections to sysfs
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au>
In-Reply-To: <87vc81lj7x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2x0dNpB5yZjMsaW7hJgYF2CfEGuSt8qc83jVV+YmaOI
 0fTS0Y8BiiJ9KEKp0loS+Ghg9EgMw4TM77LRD3XBU0nJeriNkj
 u2RvV/xCOQYhBCOAz3c72mfP+ahrz1PJNAelEb2M3Oi6J+y9s0
 cQQXZNQBj0BGHkRBam20fXJ9MfZfJIfNyP+M8V1ndk4Ayj5Hzh
 JX+djuCXMA7FZUfNjRq5+p48ETGR6fjYNC3tEBXBIbO25LZCUU
 iUbjhmiN/nMuPVrmDd+7D253rcbVEzuoV2/lyaYwSxset5XWtO
 63i8jRxX0Re+EBz5szpK5cO0MvC3bq1Gn8Z4zaSckjmcdboBwd
 mKBrf37oQYhTOvLw1o/kCvWCwX2rJVjM03Q7rLTfV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/13 06:00, Rusty Russell wrote:
> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>> On 04/04/13 03:00, Rusty Russell wrote:
>>> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>>>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
>>>> KGDB needs all module sections for proper module debugging. Therefore, commit 
>>>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
>>>> architecture.
>>> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
>>> wrong.
>> I don't see why this is wrong. It used to load all sections to sysfs
>> until the patch mentioned. Actually, it is the PARISC build chain which
>> is broken.

We worked on that topic further. Now we have another suggestion: would
it be okay to add a field to struct module for use by kgdb where we save
the section names for our use. This seems to be the most valuable
solution as solving the sysfs stuff is rather hard.
