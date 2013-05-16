Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3EPXrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:47:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48455 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3EPXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:47:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51956FF6.3070205@jp.fujitsu.com>
Date: Fri, 17 May 2013 08:47:02 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: riel@redhat.com, hughd@google.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com, linux-mm@kvack.org,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        kosaki.motohiro@jp.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        akpm@linux-foundation.org, walken@google.com, cpw@sgi.com,
        jingbai.ma@hp.com
Subject: Re: [PATCH v6 6/8] vmcore: allocate ELF note segment in the 2nd kernel
 vmalloc memory
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <20130515090614.28109.26492.stgit@localhost6.localdomain6> <20130516203236.GG5904@redhat.com>
In-Reply-To: <20130516203236.GG5904@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/17 5:32), Vivek Goyal wrote:
> On Wed, May 15, 2013 at 06:06:14PM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>
>> +static int __init get_note_number_and_size_elf32(const Elf32_Ehdr *ehdr_ptr,
>> +						 int *nr_ptnote, u64 *phdr_sz)
>> +{
>> +	return process_note_headers_elf32(ehdr_ptr, nr_ptnote, phdr_sz, NULL);
>> +}
>> +
>> +static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
>> +{
>> +	return process_note_headers_elf32(ehdr_ptr, NULL, NULL, notes_buf);
>> +}
>> +
>
> Please don't do this. We need to create two separate functions doing
> two different operations and not just create wrapper around a function
> which does two things.
>
> I know both functions will have similar for loops for going through
> the elf notes but it is better then doing function overloading based
> on parameters passed.
>

I see. This part must be fixed in the next version.

-- 
Thanks.
HATAYAMA, Daisuke

