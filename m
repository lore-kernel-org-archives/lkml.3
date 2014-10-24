Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaJXPB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:01:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29219 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaJXPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:01:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-53-544a69bda085
Message-id: <544A699B.5080806@samsung.com>
Date: Fri, 24 Oct 2014 18:00:43 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, jmorris@namei.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH v2 1/2] ima: check xattr value length in
 ima_inode_setxattr()
References: <cover.1414134113.git.d.kasatkin@samsung.com>
 <53afed717c1dc6b3588cca7c0a6b69650edc2ad2.1414134113.git.d.kasatkin@samsung.com>
 <1414160329.2120.30.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1414160329.2120.30.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xK7p7M71CDLb+4LD4srTOYvb0ZiaL
	desXM1m8nDGP3eLyrjlsFh96HrFZfFoxidmB3WPnrLvsHg8ObWbx2L3gM5NHz/dkjzMLjrB7
	fN4kF8AWxWWTkpqTWZZapG+XwJVx6/881oK32hUbd0o3ME5T6WLk5JAQMJHY8H4iE4QtJnHh
	3nq2LkYuDiGBpYwSyxb1sUA4jUwSR6dMhnJmMUq8WH0VrIVXQEtiytZGdhCbRUBVoqflHzOI
	zSagJ7Gh+QdYXFQgQuLKmjmMEPWCEj8m32MBsUUENCWOtX5kBBnKLLCOUeLH9nlgzcICwRKN
	q36ANQgJnGSUWDxHGcTmFHCXONK/CqiGA6hBXWLKlFyQMLOAvMTmNW+ZIcpVJbrXrmWDeEdR
	4vTkc8wTGIVnIVk9C6F7FpLuBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCYubrDsal
	x6wOMQpwMCrx8P7Y4hkixJpYVlyZe4hRgoNZSYT3XJpXiBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQbGpD6H9DWL/xjPrTK++Y65wk/V/6hNkf7zpF8BVq941yZZNUa2dS4OE2bina4lJ+Szhs0/
	8/CKd/IdlRoS67pv1alP+sDfdCxR/JfCbJuJV467Ofs4/xf5GqqiHblVRblpZ/K1RZyxkgZH
	p19ZJpJgdpWv88jDhovfXLjPFl18rXbs6WqHFiYlluKMREMt5qLiRAARHUkwdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 17:18, Mimi Zohar wrote:
> On Fri, 2014-10-24 at 10:07 +0300, Dmitry Kasatkin wrote: 
>> ima_inode_setxattr() can be called with no value. Function does not
>> check the length so that following command can be used to produce
>> kernel oops: setfattr -n security.ima FOO. This patch fixes it.
>>
>> Changes in v2:
>> * testing validity of xattr type
>> * allow setting hash only in fix or log mode (Mimi)
> I only mentioned "fix" mode, not "log" mode (explanation below).
>

We need it in log mode as well (explanation bellow)
>> [  261.562522] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [  261.564109] IP: [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
>> [  261.564109] PGD 3112f067 PUD 42965067 PMD 0
>> [  261.564109] Oops: 0000 [#1] SMP
>> [  261.564109] Modules linked in: bridge stp llc evdev serio_raw i2c_piix4 button fuse
>> [  261.564109] CPU: 0 PID: 3299 Comm: setxattr Not tainted 3.16.0-kds+ #2924
>> [  261.564109] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [  261.564109] task: ffff8800428c2430 ti: ffff880042be0000 task.ti: ffff880042be0000
>> [  261.564109] RIP: 0010:[<ffffffff812af272>]  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
>> [  261.564109] RSP: 0018:ffff880042be3d50  EFLAGS: 00010246
>> [  261.564109] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000015
>> [  261.564109] RDX: 0000001500000000 RSI: 0000000000000000 RDI: ffff8800375cc600
>> [  261.564109] RBP: ffff880042be3d68 R08: 0000000000000000 R09: 00000000004d6256
>> [  261.564109] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002149ba00
>> [  261.564109] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>> [  261.564109] FS:  00007f6c1e219740(0000) GS:ffff88005da00000(0000) knlGS:0000000000000000
>> [  261.564109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  261.564109] CR2: 0000000000000000 CR3: 000000003b35a000 CR4: 00000000000006f0
>> [  261.564109] Stack:
>> [  261.564109]  ffff88002149ba00 ffff880042be3df8 0000000000000000 ffff880042be3d98
>> [  261.564109]  ffffffff812a101b ffff88002149ba00 ffff880042be3df8 0000000000000000
>> [  261.564109]  0000000000000000 ffff880042be3de0 ffffffff8116d08a ffff880042be3dc8
>> [  261.564109] Call Trace:
>> [  261.564109]  [<ffffffff812a101b>] security_inode_setxattr+0x48/0x6a
>> [  261.564109]  [<ffffffff8116d08a>] vfs_setxattr+0x6b/0x9f
>> [  261.564109]  [<ffffffff8116d1e0>] setxattr+0x122/0x16c
>> [  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
>> [  261.564109]  [<ffffffff8114d011>] ? __sb_start_write+0x10f/0x143
>> [  261.564109]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
>> [  261.564109]  [<ffffffff811687c0>] ? __mnt_want_write+0x48/0x4f
>> [  261.564109]  [<ffffffff8116d3e6>] SyS_setxattr+0x6e/0xb0
>> [  261.564109]  [<ffffffff81529da9>] system_call_fastpath+0x16/0x1b
>> [  261.564109] Code: 48 89 f7 48 c7 c6 58 36 81 81 53 31 db e8 73 27 04 00 85 c0 75 28 bf 15 00 00 00 e8 8a a5 d9 ff 84 c0 75 05 83 cb ff eb 15 31 f6 <41> 80 7d 00 03 49 8b 7c 24 68 40 0f 94 c6 e8 e1 f9 ff ff 89 d8
>> [  261.564109] RIP  [<ffffffff812af272>] ima_inode_setxattr+0x3e/0x5a
>> [  261.564109]  RSP <ffff880042be3d50>
>> [  261.564109] CR2: 0000000000000000
>> [  261.599998] ---[ end trace 39a89a3fc267e652 ]---
>>
>> Reported-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/ima/ima_appraise.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
>> index 9226854..e302cbf 100644
>> --- a/security/integrity/ima/ima_appraise.c
>> +++ b/security/integrity/ima/ima_appraise.c
>> @@ -378,8 +378,17 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>>  	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
>>  				   xattr_value_len);
>>  	if (result == 1) {
>> -		ima_reset_appraise_flags(dentry->d_inode,
>> -			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
>> +		bool digsig;
>> +
>> +		if (!xattr_value_len ||
>> +		    (xvalue->type != IMA_XATTR_DIGEST &&
>> +		     xvalue->type != IMA_XATTR_DIGEST_NG &&
>> +		     xvalue->type != EVM_IMA_XATTR_DIGSIG))
> "xvalue->type" is an enumerated type.  Testing each possible value seems
> kind of a brittle method for vetting the value.  I suggest testing the
> existing last value or, better yet, define a last value, so if someone
> adds or changes the order, nothing breaks.

I was considering to define _LAST value, but we have EVM_XATTR_HMAC in
the middle...
In fact I was expecting to get some feedback about it, because in
reality it is just a sanity check.
It does not prevent DoS because it is possible to set correctly
formatted but wrong value and force DoS.

>
>> +			return -EINVAL;
>> +		digsig = (xvalue->type == EVM_IMA_XATTR_DIGSIG);
>> +		if (!digsig && (ima_appraise & IMA_APPRAISE_ENFORCE))
>> +			return -EPERM;
> According to the new ima_appraise "log" mode, commit "2faa6ef ima:
> provide 'ima_appraise=log' kernel option", "log" mode permits normal
> execution without "fixing" anything.  Normal execution, here, prevents
> writing the extended attribute.

'log' mode is also special mode for system developing and debugging.
It is beneficial to be able to 'label' target object with correct value...

- Dmitry


> Mimi
>
>> +		ima_reset_appraise_flags(dentry->d_inode, digsig);
>>  		result = 0;
>>  	}
>>  	return result;
>
>

