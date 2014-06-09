Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbaFINsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:48:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48224 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaFINsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:48:18 -0400
Message-ID: <1402321691.7064.31.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v5 4/4] KEYS: define an owner trusted keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 09:48:11 -0400
In-Reply-To: <5395B125.8010503@samsung.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401818318-15780-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <5395A4F9.1020205@samsung.com>
	 <1402318294.7064.19.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5395B125.8010503@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060913-0928-0000-0000-0000029209F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 16:05 +0300, Dmitry Kasatkin wrote: 
> On 09/06/14 15:51, Mimi Zohar wrote:
> > On Mon, 2014-06-09 at 15:13 +0300, Dmitry Kasatkin wrote: 
> >> On 03/06/14 20:58, Mimi Zohar wrote:
> >>> Instead of allowing public keys, with certificates signed by any
> >>> key on the system trusted keyring, to be added to a trusted
> >>> keyring, this patch further restricts the certificates to those
> >>> signed by a particular key on the system keyring.
> >>>
> >>> When the UEFI secure boot keys are added to the system keyring, the
> >>> platform owner will be able to load their key in one of the UEFI DBs
> >>> (eg. Machine Owner Key(MOK) list) and select their key, without
> >>> having to rebuild the kernel.
> >>>
> >>> This patch defines an owner trusted keyring, a new boot command
> >>> line option 'keys_ownerid=', and defines a new function
> >>> get_system_or_owner_trusted_keyring().
> >> Hello,
> >>
> >> The functionality of this entire patch can be replaced by only ~2 lines
> >> of code in x509_request_asymmetric_key()
> >>
> >> if (keys_ownerid || strcmp(keys_ownerid, id))
> >>      return -EPERM;
> >>
> >> Right?
> > Are you suggesting only add the one matching key to the system keyring?
> 
> No. I am not suggesting this.
> 
> All built in keys are allocated with KEY_ALLOC_TRUSTED flag and
> prep.trusted is set to "true".
> 
> So  the following statement has no effect.

Ok, so it has no affect on adding builtin keys to the system keyring.

> 
> #ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
>         ret = x509_validate_trust(cert, system_trusted_keyring);
>         if (!ret)
>             prep->trusted = 1;
> #endif

The last patch set changes the test to: 
     ret = x509_validate_trust(cert, get_system_or_owner_trusted_keyring());

> Keys which come from user-space will check for
> 
> if (keys_ownerid && strcmp(keys_ownerid, id))
>      return -EPERM;
> 
> 
> So 2 lines patch works fine..

It works based on the assumption, that you would ever only want a single
key on the 'owner' keyring, which is probably not the case.

Mimi

