Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3DOEx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:53:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33884 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3DOEx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:53:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <516B87A6.9080708@jp.fujitsu.com>
Date: Mon, 15 Apr 2013 13:52:54 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cliff Wickman <cpw@sgi.com>, Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com> <51688803.8020401@sr71.net>
In-Reply-To: <51688803.8020401@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/13 7:17), Dave Hansen wrote:
> On 04/12/2013 07:56 AM, H. Peter Anvin wrote:
>> On 04/12/2013 07:31 AM, Vivek Goyal wrote:
>>>> I also have to admit that I don't see the difference between /dev/mem
>>>> and /dev/oldmem, as the former allows access to memory ranges outside
>>>> the ones used by the current kernel, which is what the oldmem device
>>>> seems to be intended to od.
>
> It varies from arch to arch of course.
>
> But, /dev/mem has restrictions on it, like CONFIG_STRICT_DEVMEM or the
> ARCH_HAS_VALID_PHYS_ADDR_RANGE.  There's a lot of stuff that depends on
> it, *and* folks have tried to fix it up so that it's not _as_ blatant of
> a way to completely screw your system.
>
> /dev/mem also tries to be nice to arches that have restrictions like:
>
>>                          /*
>>                           * On ia64 if a page has been mapped somewhere as
>>                           * uncached, then it must also be accessed uncached
>>                           * by the kernel or data corruption may occur
>>                           */
>
> I think /dev/oldmem isn't so nice and could actually cause some real
> problems if used on ia64 where the cached/uncached accesses are mixed.

This sounds like there's no such issue on x86 cache mechanism. Is it 
correct? If so, what is the difference between ia64 and x86 cache 
mechanisms?

-- 
Thanks.
HATAYAMA, Daisuke

