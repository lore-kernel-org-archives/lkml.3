Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaIQLPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:15:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65110 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaIQLPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:15:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-6c-54196d3e44b3
Message-id: <54196D5C.6040104@samsung.com>
Date: Wed, 17 Sep 2014 14:15:40 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
To: Herbert Xu <herbert@gondor.apana.org.au>, behanw@converseincode.com
Cc: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, jbacik@fb.com, snitzer@redhat.com,
        tadeusz.struk@intel.com, akpm@linux-foundation.org,
        bruce.w.allan@intel.com, james.l.morris@oracle.com,
        john.griffin@intel.com, linux-btrfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove use of
 VLAIS in crypto code
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
 <1410766234-1634-2-git-send-email-behanw@converseincode.com>
 <20140917092212.GA1213@gondor.apana.org.au>
In-reply-to: <20140917092212.GA1213@gondor.apana.org.au>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG/e+cnXM2NnacF/5qFx1IJGQWJX9CLCPofBCSnFh9salDLae2
	paQhLdQZWqbzwjDxbmhq3kPn3dSVmhMvWYn3SgyvmaHoVs598dsD7/N7n/eBl8KEG7g9FRbx
	UCqPkISLCC4+aNSNn/GU2YndsjutUc1AP4byaqoINDAUjrT6JhKpX2pIlKdPxFH72is2Stnb
	JVDqr2MobfEmMrQU4ejTZBVAo4vlJJqd2WWhZU0+iUoTGwEa0+YRKLlAC9DG8wUCtRcocaT9
	54n0I8MkUtVtAzS73wtQb1YHGy2krZLod7kau+LAJI0aCKZFVcBmGiu+spiMhDWSedflzHxu
	vc2UtC2zmA+aPZyZ62nAmdbCLRaz+eMbzqx3TBDMdKoRYxoGHzNb9Sd8BHe4HsHS8LAYqfys
	511u6F5fMzvqNedR8UYyWwk+kimAQ0H6AtS/32SbtS0cmakhUgCXEtJlAGqMOYRpwKct4U7m
	DG7SGH0KqvOLMZMW0k9ZcCrZzwzkAlix2n0AUAeACyxdhyYPTjvDvrq6Q5agXWFtws5hsA19
	C6q7p4DJbk1fhz+LFKY1GL2Pw7ntrkO/FR0I+5dX2easJgBf6G6YNIdGsFUzR5jvOQm7x5dw
	s8cZplZXE+YyTnAwcxhLB1a5RyrkHqmQewQvBNgbYCONDopSBIbIzrsqJDJFdESIa1CkrB6Y
	v2S7GZT1X+oBNAVEPH7tGBQL2ZIYRaysB0AKE1nz03ztxEJ+sCQ2TiqPDJBHh0sVPYBFceyV
	QDtkuGbb1npRKugVUEOVo1dVPnX3OWLeH969+SRS1a8JrE82+Okuu4+vqOMtOoj8+c4Hu05/
	twTp8VlejhnaKp3v8eDTArF8jFPjLxF5i6e5ygCpYxy+ueRlwfNy82/7MvDMvcQoemKpw4tW
	OiYcJt/mNHl7fM/mNblsVvJFuCJUcs4Fkysk/wEa6S4vAwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 12:22, Herbert Xu wrote:
> On Mon, Sep 15, 2014 at 12:30:23AM -0700, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Add a macro which replaces the use of a Variable Length Array In Struct (VLAIS)
>> with a C99 compliant equivalent. This macro instead allocates the appropriate
>> amount of memory using an char array.
>>
>> The new code can be compiled with both gcc and clang.
>>
>> struct shash_desc contains a flexible array member member ctx declared with
>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
>> of the array declared after struct shash_desc with long long.
>>
>> No trailing padding is required because it is not a struct type that can
>> be used in an array.
>>
>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
>> as would be the case for a struct containing a member with
>> CRYPTO_MINALIGN_ATTR.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,

Just in case.
I would still follow advice from "Michał Mirosław" to use shash##__desc[]

- Dmitry


