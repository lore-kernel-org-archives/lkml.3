Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab3DDJks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:40:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171Ab3DDJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:40:46 -0400
Message-ID: <515D4A7F.5070102@cip.cs.fau.de>
Date: Thu, 04 Apr 2013 11:40:15 +0200
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] Add non-zero module sections to sysfs
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au>
In-Reply-To: <87mwtf3ya1.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:88uC/L2McYLmA2Y5pP+BfaE1krgj++SowBFKPCzaN3s
 Cpob18q2rsKiXNOxsEreP21thBoDJZZ7bC7NnG1CBWAvFwdM50
 wwqAHNGuktvfh8/Bt4Rp/4o2w+MZUux8xBd8kYGw7DrGxBa+F3
 O5r2dAkw3wF8s0OdAJ0IiEKkVJOJBZBZ2aNDHRWyrNioD7bE7v
 Fbu+KmVlspquaYUgcN1Kmla/33kXYasTwf4lv7XWqoGU43i6mH
 SHCufUQlEkwktEQTSQuRJNdsXz5+UqcfpQjRyCpDPtit6tWRlX
 h2DmdE0MctGVkDHxP1fGEnd4i5qns5wC9XHhmCmPthaZVJH9U1
 OR8Ih8gpZvNAhtOt3lNwNAZpuwqtm23uZIfRWjhp6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 03:00, Rusty Russell wrote:
> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
>> KGDB needs all module sections for proper module debugging. Therefore, commit 
>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
>> architecture.
> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
> wrong.

I don't see why this is wrong. It used to load all sections to sysfs
until the patch mentioned. Actually, it is the PARISC build chain which
is broken.

> My preference would be to fix kgdb.  If the section is empty, what need
> does it have to examine it?

GDB needs to know all sections of the binary and its addresses. It is
generally useful to be able to check up all sections of the binary
regardless if they are empty or not so one can see the binary's
structure. The alternative would be to redo the work by saving the ELF
header in an additional internal data structure that is not exported.
However, this approach is more ugly as it results in code which is
actually redundant.

Thanks,
Sebastian

