Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaFJNII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:08:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56075 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaFJNIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:08:07 -0400
Message-ID: <1402405679.5350.17.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/4] KEYS: define an owner trusted keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, dhowells@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        mjg59@srcf.ucam.org
Date: Tue, 10 Jun 2014 09:07:59 -0400
In-Reply-To: <20140610122434.GB31944@hansolo.jdub.homelinux.org>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
	 <f5b4ced8a93e5d824d6bf329abda2dc9d1c8751f.1402387862.git.d.kasatkin@samsung.com>
	 <20140610122434.GB31944@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061013-0928-0000-0000-00000298558A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 08:24 -0400, Josh Boyer wrote: 
> On Tue, Jun 10, 2014 at 11:48:15AM +0300, Dmitry Kasatkin wrote:
> > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > 
> > Instead of allowing public keys, with certificates signed by any
> > key on the system trusted keyring, to be added to a trusted
> > keyring, this patch further restricts the certificates to those
> > signed by a particular key on the system keyring.
> > 
> > When the UEFI secure boot keys are added to the system keyring, the
> > platform owner will be able to load their key in one of the UEFI DBs
> > (eg. Machine Owner Key(MOK) list) and select their key, without
> > having to rebuild the kernel.
> > 
> > This patch defines an owner trusted keyring, a new boot command
> > line option 'keys_ownerid=', and defines a new function
> > get_system_or_owner_trusted_keyring().
> > 
> > Signed-off-by: Mimi Zohar<zohar@linux.vnet.ibm.com>
> > ---
> >  Documentation/kernel-parameters.txt      |  5 ++
> >  crypto/asymmetric_keys/x509_public_key.c |  4 +-
> >  include/keys/owner_keyring.h             | 27 ++++++++++
> >  init/Kconfig                             | 10 ++++
> >  kernel/Makefile                          |  1 +
> >  kernel/owner_keyring.c                   | 85 ++++++++++++++++++++++++++++++++
> >  6 files changed, 131 insertions(+), 1 deletion(-)
> >  create mode 100644 include/keys/owner_keyring.h
> >  create mode 100644 kernel/owner_keyring.c
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 7116fda..f90d31d 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1434,6 +1434,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			use the HighMem zone if it exists, and the Normal
> >  			zone if it does not.
> >  
> > +	keys_ownerid=[KEYS] This parameter identifies a specific key on
> > +			the system trusted keyring to be added to the
> > +			owner trusted keyring.
> > +			format: id:<keyid>
> > +
> 
> I'm fairly sure this runs into the same problems I mentioned previously
> in the secure boot context.  Namely that a remote attacker could modify
> keys_ownerid in the bootloader config file if they gained root access.

Yes, someone could specify a key not in the UEFI DB or builtin, but it
would not do them much good.  The "keys_ownerid" searches the
UEFI/builtin keys for the keyid.

Mimi

