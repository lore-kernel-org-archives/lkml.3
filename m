Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3DOH6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:58:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34604 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DOH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:58:46 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <516BB310.20209@jp.fujitsu.com>
Date: Mon, 15 Apr 2013 16:58:08 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Cliff Wickman <cpw@sgi.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com> <51688803.8020401@sr71.net> <516B87A6.9080708@jp.fujitsu.com> <516B9714.80007@sr71.net>
In-Reply-To: <516B9714.80007@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/15 14:58), Dave Hansen wrote:
> On 04/14/2013 09:52 PM, HATAYAMA Daisuke wrote:
>> This sounds like there's no such issue on x86 cache mechanism. Is it
>> correct? If so, what is the difference between ia64 and x86 cache
>> mechanisms?
>
> I'm just going by the code comments:
>
> drivers/char/mem.c
>>                  /*
>>                   * On ia64 if a page has been mapped somewhere as uncached, then
>>                   * it must also be accessed uncached by the kernel or data
>>                   * corruption may occur.
>>                   */

I think it reasonable, in complexity of design, to decide cache or 
uncache according to whether target memory is RAM or some device. If 
we're concerned about page levels, things are to be complicated further 
since memory typing is done per pages. How large does such table become 
to represent memory types for all the target pages, how do we create it 
and when? (I don't know ia64 but I guess caching on ia64 is also done in 
per pages just like x86...)

-- 
Thanks.
HATAYAMA, Daisuke

