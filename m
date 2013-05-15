Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3EOI0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:26:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55800 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3EOI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:26:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51934685.9080909@jp.fujitsu.com>
Date: Wed, 15 May 2013 17:25:41 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH v5 7/8] vmcore: calculate vmcore file size from buffer
 size and total size of vmcore objects
References: <20130514015622.18697.77191.stgit@localhost6.localdomain6> <20130514015746.18697.1089.stgit@localhost6.localdomain6> <20130514164739.GJ13674@redhat.com>
In-Reply-To: <20130514164739.GJ13674@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/15 1:47), Vivek Goyal wrote:
> On Tue, May 14, 2013 at 10:57:46AM +0900, HATAYAMA Daisuke wrote:
>> The previous patches newly added holes before each chunk of memory and
>> the holes need to be count in vmcore file size. There are two ways to
>> count file size in such a way:
>>
>> 1) supporse p as a poitner to the last program header entry with
>> PT_LOAD type, then roundup(p->p_offset + p->p_memsz, PAGE_SIZE), or

This part was wrong. This should have been:

1) support m as a pointer to the last vmcore object in vmcore_list, then 
file size is (m->offset + m->size), or

I'll correct this way in next patch.

Note that no functional change, only description is wrong here.

-- 
Thanks.
HATAYAMA, Daisuke

