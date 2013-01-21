Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3AUBxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:53:54 -0500
Received: from ozlabs.org ([203.10.76.45]:52322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3AUBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:53:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Samuel <chris@csamuel.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when module signature checking fails
In-Reply-To: <20130121113430.460efbd10537801cab90af5b@canb.auug.org.au>
References: <50F67D75.9080508@csamuel.org> <87a9s3xw9g.fsf@rustcorp.com.au> <20130121113430.460efbd10537801cab90af5b@canb.auug.org.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 12:11:03 +1030
Message-ID: <87d2wzwbww.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Rusty,
>
> On Mon, 21 Jan 2013 10:06:11 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>>  #ifdef CONFIG_MODULE_SIG
>>  	mod->sig_ok = info->sig_ok;
>> -	if (!mod->sig_ok)
>> +	if (!mod->sig_ok) {
>> +		printk_once(KERN_NOTICE
>> +			    "%s: module verification failed: signature and/or"
>> +			    " required key missing - tainting kernel\n");
>
> Did you forget to add "mod->name"?

Indeed (turns back on CONFIG_MODULE_SIG).

Thanks,
Rusty.

