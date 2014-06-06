Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaFFXWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:22:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19852 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaFFXWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:22:00 -0400
Message-ID: <53924D10.4050305@oracle.com>
Date: Fri, 06 Jun 2014 19:21:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc8 mm/filemap.c:202 BUG
References: <20140603042121.GA27177@redhat.com>	<CALYGNiNV951SnBKdr0PEkgLbLCxy+YB6HJpafRr6CynO+a1sdQ@mail.gmail.com>	<alpine.LSU.2.11.1406031524470.7878@eggly.anvils>	<538F121E.9020100@oracle.com>	<alpine.LSU.2.11.1406061549500.9818@eggly.anvils> <CA+55aFy939whF-vo+GyOhkyqgOEUGqAt-cmAB2gSOFHKBeGCPA@mail.gmail.com>
In-Reply-To: <CA+55aFy939whF-vo+GyOhkyqgOEUGqAt-cmAB2gSOFHKBeGCPA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 07:16 PM, Linus Torvalds wrote:
>> I have no evidence that its lack is responsible for the mm/filemap.c:202
>> > BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by trinity,
>> > and I am not optimistic that it will fix it.  But I have found no other
>> > explanation, and ACCESS_ONCE() here will surely not hurt.
> The patch looks obviously correct to me, although like you, I have no
> real reason to believe it really fixes anything. But we definitely
> should just load it once, since it's very much an optimistic load done
> before we take the real lock and re-compare.
> 
> I'm somewhat dubious whether it actually would change code generation
> - it doesn't change anything with the test-configuration I tried with
> - but it's unquestionably a good patch. And hey, maybe some
> configurations have sufficiently different code generation that gcc
> actually _can_ sometimes do reloads, perhaps explaining why some
> people see problems. So it's certainly worth testing even if it
> doesn't make any change to code generation with *my* compiler and
> config..

I'm seeing the same code generated here as well. I won't carry the
patch unless Andrew/Linus take it so it won't hide possible bugs that
trinity might stumble on.


Thanks,
Sasha
