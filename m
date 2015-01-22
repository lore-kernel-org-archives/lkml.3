Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbbAVSJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:09:05 -0500
Received: from smtp107.biz.mail.bf1.yahoo.com ([98.139.244.55]:32612 "EHLO
	smtp107.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbbAVSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:09:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XcdeYVkVM1loBxdNZ4zjOtPcRoh1k5WgQO9MSdIDm6ESb6h
 ZXWhRx1dZAGoQsiUjGuZUccft0ay1o77hKtMOu6Uln4eUC4j5tYrhFmCp97n
 Z2zTHmxdybA7MoBTfXFRHN2UsKL2NFKtmRTYt69gLzTywF9A9W9_3GV6umZl
 NF_8DqQ8lh_eL0UE0HY9aAU0CDAwuSxEkYjKTjGfuCHBGooNqlA7boLGZ9Ga
 6zhS1n88ByVg5PVmHUhVhP3XRTcPXZiVoBFHoOyhcVe7nxmARPPTDDhdQ2xE
 7ZCofYCfOM7le9vbbxU6vFpQlC3.f.JQY73iuLhSrllBx669oOHErslJJfsb
 5a3f9O6vb3QK4_WG0AonlNb6X8UdVhJCj86GXJzWTLHuaFodkX63uUZXivxQ
 KmHweU91Y_4Tdrw2wU70Jcl.nnz3HqviH9xgxZRJWGYdfiBmS.DMqZ5qpnw9
 Eb5xufc1Ng0OD5k30BIKIOmGtwvHl0mPJ5evQIJO7kh_vhdTnebeR_0YSqQe
 i0P6UW9Wha1Bm06qIVuV7Qy.IoAk-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54C13CBC.3050004@schaufler-ca.com>
Date: Thu, 22 Jan 2015 10:09:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Stephen Smalley <sds@tycho.nsa.gov>
CC: linux-kernel@vger.kernel.org, arve@android.com, nnk@google.com,
        paul@paul-moore.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Add security hooks to binder and implement the hooks
 for SELinux.
References: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov> <20150122085150.GB1268@kroah.com>
In-Reply-To: <20150122085150.GB1268@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2015 12:51 AM, Greg KH wrote:
> On Wed, Jan 21, 2015 at 10:54:10AM -0500, Stephen Smalley wrote:
>> Add security hooks to the binder and implement the hooks for SELinux.
>> The security hooks enable security modules such as SELinux to implement
>> controls over binder IPC.  The security hooks include support for
>> controlling what process can become the binder context manager
>> (binder_set_context_mgr), controlling the ability of a process
>> to invoke a binder transaction/IPC to another process (binder_transaction),
>> controlling the ability of a process to transfer a binder reference to
>> another process (binder_transfer_binder), and controlling the ability
>> of a process to transfer an open file to another process (binder_transfer_file).
>>
>> These hooks have been included in the Android kernel trees since Android 4.3.
> Very interesting, I missed the fact that these were added in that tree,
> thanks for digging it out and submitting it.
>
> I'd like some acks from some Android developers before I take these.
> Or, if it's easier for them to go through the security tree, that's fine
> with me as well.

My only concern is that we're about to see a set of hooks proposed
for kdbus as well, and it would be a shame if we had two sets of hooks
that do roughly the same thing (ok, *very roughly*) introduced back to back.

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

