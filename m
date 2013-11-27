Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3K0Ms2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:48:28 -0500
Received: from fm1nodo5.polito.it ([130.192.180.13]:60580 "EHLO
	fm1nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab3K0MsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:48:25 -0500
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <5295E9B3.202@polito.it>
Date: Wed, 27 Nov 2013 13:46:43 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com> <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com> <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org> <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com> <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org> <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com> <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com> <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org> <52939AEE.5070809@polito.it> <52939D11.70302@polito.it> <alpine.LFD.2.10.1311271301430.1885@c4eb>
In-Reply-To: <alpine.LFD.2.10.1311271301430.1885@c4eb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-SYSTEM-WL: 130.192.180.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 01:11 PM, Sebastian Ott wrote:
> Hello,
>
> On Mon, 25 Nov 2013, Roberto Sassu wrote:
>
>> On 11/25/2013 07:46 PM, Roberto Sassu wrote:
>>> On 11/25/2013 04:40 PM, James Morris wrote:
>>>> On Mon, 25 Nov 2013, Mimi Zohar wrote:
>>>>
>>>>> Hi James,
>>>>>
>>>>> These are the "essential fixes for regressions".
>>>>>
>>>>> The following changes since commit
>>>>> 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
>>>>>
>>>>>     Revert "KEYS: verify a certificate is signed by a 'trusted' key"
>>>>> (2013-11-23 16:38:17 -0800)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity
>>>>> for-linus
>>>>>
>>>>> for you to fetch changes up to 72ca1bd303a5126d0ce377cff699282b6b38bd86:
>>>>>
>>>>>     ima: make a copy of template_fmt in template_desc_init_fields()
>>>>> (2013-11-25 07:32:46 -0500)
>>>>>
>>>>> thanks,
>>>>>
>>>>> Mimi
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Roberto Sassu (3):
>>>>
>>>>>         ima: make a copy of template_fmt in template_desc_init_fields()
>
> commit dbc335d2dc3c437649eb6b39f4e9aee2a13eb0af
> "ima: make a copy of template_fmt in template_desc_init_fields()"
>
> claimed to fix a kstrdup memleak..looks like it didn't:
>
> unreferenced object 0x56c82370 (size 8):
>    comm "swapper/0", pid 1, jiffies 4294937476 (age 916.520s)
>    hex dump (first 8 bytes):
>      64 00 6e 00 6b 6b 6b a5                          d.n.kkk.
>    backtrace:
>      [<000000000027c7ac>] __kmalloc_track_caller+0x2e0/0x450
>      [<0000000000240738>] kstrdup+0x4c/0xd0
>      [<00000000003c93c4>] ima_init_template+0x9c/0x1f4
>      [<0000000000a11a54>] ima_init+0x74/0x98
>      [<0000000000a11ba8>] init_ima+0x30/0x4c
>      [<00000000001001e2>] do_one_initcall+0xce/0x160
>      [<00000000009ebb70>] kernel_init_freeable+0x22c/0x2dc
>      [<000000000061b704>] kernel_init+0x24/0x134
>      [<0000000000633322>] kernel_thread_starter+0x6/0xc
>      [<000000000063331c>] kernel_thread_starter+0x0/0xc
> unreferenced object 0x56ccc158 (size 16):
>    comm "swapper/0", pid 1, jiffies 4294937476 (age 916.520s)
>    hex dump (first 16 bytes):
>      64 2d 6e 67 00 6e 2d 6e 67 00 73 69 67 00 6b a5  d-ng.n-ng.sig.k.
>    backtrace:
>      [<000000000027c7ac>] __kmalloc_track_caller+0x2e0/0x450
>      [<0000000000240738>] kstrdup+0x4c/0xd0
>      [<00000000003c93c4>] ima_init_template+0x9c/0x1f4
>      [<0000000000a11a54>] ima_init+0x74/0x98
>      [<0000000000a11ba8>] init_ima+0x30/0x4c
>      [<00000000001001e2>] do_one_initcall+0xce/0x160
>      [<00000000009ebb70>] kernel_init_freeable+0x22c/0x2dc
>      [<000000000061b704>] kernel_init+0x24/0x134
>      [<0000000000633322>] kernel_thread_starter+0x6/0xc
>      [<000000000063331c>] kernel_thread_starter+0x0/0xc
>
>
> strsep will modify your template_fmt_copy pointer.
>

Hi Sebastian

thanks for the report. I'm very sorry.
I should have prepared the patch more carefully.
I'll provide a fix shortly.

Thanks

Roberto Sassu


> Regards,
> Sebastian
>
>>>>
>>>>
>>>>> template_desc_init_fields(char *template_fmt,
>>>>
>>>> That should probably be const char.
>>>>
>>>> Also, the call to kstrdup() results in a memory leak.
>>>>
>>>
>>> Hi James
>>>
>>> thanks for the comments. I'm implementing them and I will post
>>> a new version of the patch 'ima: make a copy of template_fmt in
>>> template_desc_init_fields()' shortly.
>>>
>>
>> Hi everyone
>>
>> attached to this email, there is the new version of the above patch.
>>
>> Regards
>>
>> Roberto Sassu
>>
>>
>>> Roberto Sassu
>>>
>>>
>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>

