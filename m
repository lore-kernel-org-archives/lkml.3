Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaBXWd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:33:57 -0500
Received: from smtp104.biz.mail.ne1.yahoo.com ([98.138.207.11]:28063 "HELO
	smtp104.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752327AbaBXWd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:33:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: c7hCkDoVM1l2QyZra1fUdIrTI1a2.n_RSYBCWkOtr4qLWO0
 Qku8mxNmtM3_itH3eNYuVQcK_iupyVN5yR.Vf1Bt5dV2kM_OEjlrEySPZFQM
 561ttdEtdB7jQNhA_L7hvxofe0_sWSv9zQ0EvHiPVvImzyK9ouHCw2k6RErj
 Yt7XcSLA5dHLXY.xaQCLIHlv4dBANOVxbJcYGHK.wa6iPWVv8gT_Ko1KNdKH
 Bimb9r2HgamSC6rfP1biQiReB0XpXtX3h_VrA9uzPN8a7mFgqzhruT.zns4i
 wUXrtmhF68RxTImEV30U4KtcvtuKZjVLOsoGJ3eV88NbkZTfHxQrCiKo0wHt
 V4H_0GJyfuF92OIrhXT_RcFi3kRbhtQmSdznnwZ98Cv2noJpQJD5WGua4B3M
 Enat_L4ac_9Xg6bBXjsqiqePSovPiCCoNlVPHXxgsSau0rr0WXCPri5lGTNE
 GsZWtCvQJR8Jx4opXgT79x4TCGh_KQZF3aOKyljyXn75qUmmAzuEjGWLAT73
 5LeSJpzFGFIs5vcCZH8ZPP8ad1uLd0pDSK6rBtlkL5m8K
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp104.biz.mail.ne1.yahoo.com with SMTP; 24 Feb 2014 14:33:55 -0800 PST
Message-ID: <530BC8D2.9050503@schaufler-ca.com>
Date: Mon, 24 Feb 2014 14:33:54 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 6/8] security: smack: Use a more current logging style
References: <cover.1393279025.git.joe@perches.com>	 <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com>	 <530BC4BF.2000904@schaufler-ca.com> <1393280598.11020.77.camel@joe-AO722>
In-Reply-To: <1393280598.11020.77.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2014 2:23 PM, Joe Perches wrote:
> On Mon, 2014-02-24 at 14:16 -0800, Casey Schaufler wrote:
>> On 2/24/2014 1:59 PM, Joe Perches wrote:
>>> Convert printks to pr_<level>
>>> Add pr_fmt.
>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> []
>>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> +
>> What is pr_fmt() for?
> Prefixing "smack: " to the pr_<level> uses.

OK. I didn't see where it was used. I understand now. I'll go
back and ACK the changes.

>
>>> @@ -2106,8 +2108,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
>>>  		if (sock->sk->sk_family == PF_INET) {
>>>  			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
>>>  			if (rc != 0)
>>> -				printk(KERN_WARNING
>>> -					"Smack: \"%s\" netlbl error %d.\n",
>>> +				pr_warn("\"%s\" netlbl error %d\n",
>>>  					__func__, -rc);
> This will be now be emitted as
>
> <4>smack: "smack_inode_setsecurity" netlbl error -<d>
>
> instead of
>
> <4>Smack: "smack_inode_setsecurity" netlbl error -<d>
>
> Though it'd be a lot more common to use:
>
> 					pr_warn("%s: netlbl error: %d\n",
> 						__func__, -rc);
>
> so the output would be:
>
> <4>smack: smack_inode_setsecurity: netlbl error: -<d>
>
>
>

