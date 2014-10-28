Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaJ1MeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:34:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49511 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaJ1MeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:34:05 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-6e-544f8d3a8826
Message-id: <544F8D12.2030104@samsung.com>
Date: Tue, 28 Oct 2014 14:33:22 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] evm: check xattr value length and type in
 evm_inode_setxattr()
References: <cover.1414494901.git.d.kasatkin@samsung.com>
 <5fccfb5344bad84eb87096dd6b9d5a775dc11efb.1414494901.git.d.kasatkin@samsung.com>
In-reply-to: <5fccfb5344bad84eb87096dd6b9d5a775dc11efb.1414494901.git.d.kasatkin@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xa7pWvf4hBv+myll8WVpnMXt6M5PF
	uvWLmSxezpjHbnF51xw2iw89j9gsFmx8xGjxacUkZgcOj52z7rJ7PDi0mcVj94LPTB4935M9
	ziw4wu7xeZNcAFsUl01Kak5mWWqRvl0CV8bJqUfZCpYqVcx5vJKtgfGhTBcjJ4eEgInE5Y7f
	bBC2mMSFe+uBbC4OIYGljBL/Z++FchqZJN403WUGqRISmMUo0XfeFMTmFdCSeP1xHiOIzSKg
	KrH8ezsLiM0moCexofkHO4gtKhAhcWXNHEaIekGJH5PvgdWICORIPPrzGqyGWaBMYs2tNlYQ
	W1ggRmLzsw/MEIt7gK748g7sPE6BeIlVlxYDFXEANehJ3L+oBdErL7F5zVuo21QluteuhfpG
	UeL05HPMExiFZyFZPQuhexaS7gWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQqLnyw7G
	xcesDjEKcDAq8fDumOYbIsSaWFZcmXuIUYKDWUmENyLGP0SINyWxsiq1KD++qDQntfgQIxMH
	p1QDo/OSok6Hu9Gr0qqyuzZVzu3x36ecv2r1IYvdDUsSrr/M3pE1a3VtirbRn1QVtmC9kOdv
	uOf2PIl5Lvgj+t/Nj8nu6+/XbmP4Vbem43VQ0HPD7/w27rekT09ZOdP+m52Caq36N1/OsuMP
	vxm98dj5gTdy+++kVhmFd5M2s6jnL0tcdrzyxKK4R0osxRmJhlrMRcWJAPplMrJ8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this was the wrong version of the patch.
Please ignore this patch and use what is in the reply to this patch:
[PATCH v3 1/1] evm: check xattr value length and type in
evm_inode_setxattr()

- Dmitry

On 28/10/14 13:31, Dmitry Kasatkin wrote:
> evm_inode_setxattr() can be called with no value. The function does not
> check the length so that following command can be used to produce the
> kernel oops: setfattr -n security.evm FOO. This patch fixes it.
>
> Changes in v2:
> * testing for validity of xattr type
>
> [ 1106.396921] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 1106.398192] IP: [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
> [ 1106.399244] PGD 29048067 PUD 290d7067 PMD 0
> [ 1106.399953] Oops: 0000 [#1] SMP
> [ 1106.400020] Modules linked in: bridge stp llc evdev serio_raw i2c_piix4 button fuse
> [ 1106.400020] CPU: 0 PID: 3635 Comm: setxattr Not tainted 3.16.0-kds+ #2936
> [ 1106.400020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 1106.400020] task: ffff8800291a0000 ti: ffff88002917c000 task.ti: ffff88002917c000
> [ 1106.400020] RIP: 0010:[<ffffffff812af7b8>]  [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
> [ 1106.400020] RSP: 0018:ffff88002917fd50  EFLAGS: 00010246
> [ 1106.400020] RAX: 0000000000000000 RBX: ffff88002917fdf8 RCX: 0000000000000000
> [ 1106.400020] RDX: 0000000000000000 RSI: ffffffff818136d3 RDI: ffff88002917fdf8
> [ 1106.400020] RBP: ffff88002917fd68 R08: 0000000000000000 R09: 00000000003ec1df
> [ 1106.400020] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800438a0a00
> [ 1106.400020] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1106.400020] FS:  00007f7dfa7d7740(0000) GS:ffff88005da00000(0000) knlGS:0000000000000000
> [ 1106.400020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1106.400020] CR2: 0000000000000000 CR3: 000000003763e000 CR4: 00000000000006f0
> [ 1106.400020] Stack:
> [ 1106.400020]  ffff8800438a0a00 ffff88002917fdf8 0000000000000000 ffff88002917fd98
> [ 1106.400020]  ffffffff812a1030 ffff8800438a0a00 ffff88002917fdf8 0000000000000000
> [ 1106.400020]  0000000000000000 ffff88002917fde0 ffffffff8116d08a ffff88002917fdc8
> [ 1106.400020] Call Trace:
> [ 1106.400020]  [<ffffffff812a1030>] security_inode_setxattr+0x5d/0x6a
> [ 1106.400020]  [<ffffffff8116d08a>] vfs_setxattr+0x6b/0x9f
> [ 1106.400020]  [<ffffffff8116d1e0>] setxattr+0x122/0x16c
> [ 1106.400020]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
> [ 1106.400020]  [<ffffffff8114d011>] ? __sb_start_write+0x10f/0x143
> [ 1106.400020]  [<ffffffff811687e8>] ? mnt_want_write+0x21/0x45
> [ 1106.400020]  [<ffffffff811687c0>] ? __mnt_want_write+0x48/0x4f
> [ 1106.400020]  [<ffffffff8116d3e6>] SyS_setxattr+0x6e/0xb0
> [ 1106.400020]  [<ffffffff81529da9>] system_call_fastpath+0x16/0x1b
> [ 1106.400020] Code: c3 0f 1f 44 00 00 55 48 89 e5 41 55 49 89 d5 41 54 49 89 fc 53 48 89 f3 48 c7 c6 d3 36 81 81 48 89 df e8 18 22 04 00 85 c0 75 07 <41> 80 7d 00 02 74 0d 48 89 de 4c 89 e7 e8 5a fe ff ff eb 03 83
> [ 1106.400020] RIP  [<ffffffff812af7b8>] evm_inode_setxattr+0x2a/0x48
> [ 1106.400020]  RSP <ffff88002917fd50>
> [ 1106.400020] CR2: 0000000000000000
> [ 1106.428061] ---[ end trace ae08331628ba3050 ]---
>
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  security/integrity/evm/evm_main.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index b392fe6..1384e4b 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -324,9 +324,14 @@ int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>  {
>  	const struct evm_ima_xattr_data *xattr_data = xattr_value;
>  
> -	if ((strcmp(xattr_name, XATTR_NAME_EVM) == 0)
> -	    && (xattr_data->type == EVM_XATTR_HMAC))
> -		return -EPERM;
> +	if (strcmp(xattr_name, XATTR_NAME_EVM) == 0) {
> +		if (!xattr_value_len)
> +			return -EINVAL;
> +		if (xattr_data->type == EVM_XATTR_HMAC)
> +			return -EPERM;
> +		if (xattr_data->type != EVM_IMA_XATTR_DIGSIG)
> +			return -EINVAL;
> +	}
>  	return evm_protect_xattr(dentry, xattr_name, xattr_value,
>  				 xattr_value_len);
>  }

