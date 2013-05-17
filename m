Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3EQBqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:46:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48590 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3EQBql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:46:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51958BC0.207@jp.fujitsu.com>
Date: Fri, 17 May 2013 10:45:36 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 0/8] kdump, vmcore: support mmap() on /proc/vmcore
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <51957469.2000008@zytor.com>
In-Reply-To: <51957469.2000008@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/17 9:06), H. Peter Anvin wrote:
> On 05/15/2013 02:05 AM, HATAYAMA Daisuke wrote:
>> Currently, read to /proc/vmcore is done by read_oldmem() that uses
>> ioremap/iounmap per a single page. For example, if memory is 1GB,
>> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
>> times. This causes big performance degradation.
>
> read_oldmem() is fundamentally broken and unsafe.  It needs to be
> unified with the plain /dev/mem code and any missing functionality fixed
> instead of "let's just do a whole new driver".
>
> 	-hpa

Do you mean range_is_allowed should be extended so that it checks 
according to memory map passed from the 1st kernel?

BTW, read request to read_oldmem via read_vmcore and mmap on some part 
of the 1st kernel, seems safe since it's always restrected to within the 
memory map.

Or is there other missing point?

-- 
Thanks.
HATAYAMA, Daisuke

