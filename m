Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaJ0RHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:07:55 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57490 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJ0RHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:07:54 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-c8-544e7be89b56
Message-id: <544E7BE6.8040102@samsung.com>
Date: Mon, 27 Oct 2014 20:07:50 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 07/12] mm: slub: share slab_err and object_err functions
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-8-git-send-email-a.ryabinin@samsung.com>
 <1414429203.8884.12.camel@perches.com>
In-reply-to: <1414429203.8884.12.camel@perches.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xq7ovqv1CDLYv5bP4vXcmq8Wc9WvY
	LI5c+85ucf3bG0aLTy8fMFpsud7EZPH84UN2iwkP29gtpm0Ut1jZ3cxmMfv+YxaL7c/eMlms
	7HzAanF51xw2i3tr/rNatH3+BySWbGSyWHzkNrPFu2eTmS2urjrIbvFjw2NWB1GP+Ts/Mnrs
	nHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeHxZdY3Z4/2+
	q2wenzfJeZxo+cIawBfFZZOSmpNZllqkb5fAlbFo0x7mglOsFc0t/9kaGI+ydDFyckgImEhM
	aWuAssUkLtxbz9bFyMUhJLCUUeLy1RmMEE4zk8SZIy+Zuhg5OHgFtCQa/tiANLAIqErcW7AR
	rJlNQE/i36ztbCC2qECExJU1cxhBbF4BQYkfk++xgLSKCChK3N3CDzKSWeAiq8Sk84vAeoUF
	/CWWP5jFDLHrBaPE1edP2UEaOAWMJbb25oGYzEDz71/UAilnFpCX2LzmLfMERoFZSDbMQqia
	haRqASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQGP66g3HpMatDjAIcjEo8vBOKfUOE
	WBPLiitzDzFKcDArifAeSPMLEeJNSaysSi3Kjy8qzUktPsTIxMEp1cB4cImmyc91DctV7/zb
	LPH7/ZU169LP67fImGUIP/DedbJnscG6pHsmW29MmHtA80Pm/HbXZ1ybzrG3frKZFTshwMul
	+pGmv9NX5Z9b17On8PRNyJLw5Tn0rb1V0V3xq5TGy0K/3wzbltuLllmE5mU1fj111On4aq2A
	m9dmn4p+W3FeObgie/ksJZbijERDLeai4kQA87V6pb8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 08:00 PM, Joe Perches wrote:
> On Mon, 2014-10-27 at 19:46 +0300, Andrey Ryabinin wrote:
>> Remove static and add function declarations to mm/slab.h so they
>> could be used by kernel address sanitizer.
> []
>> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> []
>> @@ -115,4 +115,8 @@ static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
> []
>> +void slab_err(struct kmem_cache *s, struct page *page, const char *fmt, ...);
>> +void object_err(struct kmem_cache *s, struct page *page,
>> +		u8 *object, char *reason);
> 
> Please add __printf(3, 4) to have the compiler catch
> format and argument mismatches.
> 
> 

Will do, thanks.
