Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3JBBHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:07:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44161 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3JBBHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:07:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <524B7179.7040104@jp.fujitsu.com>
Date: Wed, 02 Oct 2013 10:06:01 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-7-git-send-email-keescook@chromium.org> <524B6AEE.90301@jp.fujitsu.com>
In-Reply-To: <524B6AEE.90301@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/02 9:38), HATAYAMA Daisuke wrote:
> (2013/10/02 4:37), Kees Cook wrote:
<cut>
>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>    }
>>    
>>    #endif /* CONFIG_X86_32 */
>> +
>> +static struct notifier_block kernel_offset_notifier = {
>> +	.notifier_call = dump_kernel_offset
>> +};
>> +
>> +static int __init register_kernel_offset_dumper(void)
>> +{
>> +	atomic_notifier_chain_register(&panic_notifier_list,
>> +					&kernel_offset_notifier);
>> +	return 0;
>> +}
>> +__initcall(register_kernel_offset_dumper);
>>
> 
> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
> kdump? Anyway, kdump related tools now calculate phys_base from memory map
> information passed as ELF PT_LOAD entries like below.

Another simpler way is to print this information at boot time, not at panic.

-- 
Thanks.
HATAYAMA, Daisuke

