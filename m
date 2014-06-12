Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaFLRhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:37:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51948 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaFLRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:37:45 -0400
Message-ID: <1402594657.5318.41.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/4] KEYS: validate key trust only with selected owner
 key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, dhowells@redhat.com,
        jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, mjg59@srcf.ucam.org
Date: Thu, 12 Jun 2014 13:37:37 -0400
In-Reply-To: <20140612173236.GK9578@redhat.com>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
	 <ef22f2630a2545bd7c3bf2c9e730a842835cf6c4.1402387862.git.d.kasatkin@samsung.com>
	 <20140612160346.GG9578@redhat.com> <5399E22D.9070205@samsung.com>
	 <20140612173236.GK9578@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061217-0928-0000-0000-0000029BA824
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 13:32 -0400, Vivek Goyal wrote: 
> On Thu, Jun 12, 2014 at 08:23:57PM +0300, Dmitry Kasatkin wrote:
> > On 12/06/14 19:03, Vivek Goyal wrote:
> > > On Tue, Jun 10, 2014 at 11:48:17AM +0300, Dmitry Kasatkin wrote:
> > >> This patch provides kernel parameter to specify owner's key id which
> > >> must be used for trust validate of keys. Keys signed with other keys
> > >> are not trusted.
> > >>
> > >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > > Hi,
> > >
> > > I am continuing to work on verifying kernel signature for kexec/kdump. I 
> > > am planning to take david howell's patches for pkcs7 signature
> > > verification and verify bzImage signature.
> > >
> > > Part of that process will boil down to verifying a certificate in
> > > pkcs7 x509 cert chain using a key in system_trusted_keyring.
> > >
> > > I think the OS vendor key which signs the kernel signing key propagates to
> > > system_trusted_keyring. (shim has that and I am not sure how shim makes
> > > it propogate all they way to system_trusted_keyring).
> > >
> > > So I was planning to use same functionality where I look for any key
> > > which can verify the signing cert of kernel. As OS vendor key will be
> > > in system_trusted_keyring, it should work.
> > >
> > > Now with this change where you will trust only one selected owner key.
> > > That means you will not even trust the OS vendor key which signs kernel
> > > signing key. I think this will stop working with  keys_ownerid=<....>
> > >
> > > As I am doing that work in parallel and I saw these patches, I thought
> > > I will bring it up.
> > 
> > Hi Vivek,
> > 
> > All keys stays in the keyring. Usage of owner_keyid is limited to
> > validate the trust of the loaded keys.
> 
> Hi Dmitry,
> 
> If owner_keyid scope is just limited to loading extra keys, then it
> should be fine as I don't want to load extra keys. I just want to
> verify already signed image whose key is supposed to be in
> system_trusted_keyring.

Yes, sorry my mistake.

Mimi

> > 
> > 
> > Do you really see OS verndor key (Fedora) on the system keyring?
> > shim is UEFI binary and can add it to the MOK database..
> 
> I have been told that mechanism to propagate they key in shim which is
> used to verify kernel signature is in place and that key should show
> up in system_trusted_keyring. I have never verified it though. I will
> check it out.
> 
> Thanks
> Vivek
> 


