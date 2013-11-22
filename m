Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3KVGYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:24:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48065 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3KVGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:24:40 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528EF87D.4050300@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 15:23:57 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230>
In-Reply-To: <1385078632.12107.3.camel@x230>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/22 9:03), Matthew Garrett wrote:
> On Fri, 2013-11-22 at 09:00 +0900, Yasuaki Ishimatsu wrote:
>> (2013/11/22 5:12), Matthew Garrett wrote:
>>> On Thu, 2013-11-21 at 18:35 +0900, Yasuaki Ishimatsu wrote:
>>>
>>>> Remaining space is free space that can be used by efi variable. But by 5KB
>>>> threshold, we cannot use the space while running OS.
>>>
>>> Is the situation something like(assuming a 128KB flash part):
>>>
>>> 1) 64KB of variables, 59KB of deleted variables, 5KB of free space,
>>
>> My situation looks like this. The free space spreads out if gc runs.
>
> Ok. In that case Joey's suggestion that we try forcing a GC run in the
> boot stub if free space < (threshold * 2) might be the best plan.
>
 > 2) 123KB of variables, 5KB of free space

I don't know how to implement your idea. But if GC run by your idea, the free
space may spread out. So 1) case is solved. But it does not solve 2) case.
In my opinion, if system has sane firmware, all nvram strage should be used.
I will send whiltelist version which used DMI infomation. Please review it.

Thanks,
Yasuaki Ishimatsu



