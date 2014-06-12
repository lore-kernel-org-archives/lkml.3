Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaFLRRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:17:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45837 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaFLRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:17:14 -0400
Message-ID: <1402593423.5318.39.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/4] KEYS: validate key trust only with selected owner
 key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, dhowells@redhat.com,
        jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dmitry.kasatFionnuala Gunter" <fin@linux.vnet.ibm.com>, kin@gmail.com,
        mjg59@srcf.ucam.org
Date: Thu, 12 Jun 2014 13:17:03 -0400
In-Reply-To: <20140612170044.GI9578@redhat.com>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
	 <ef22f2630a2545bd7c3bf2c9e730a842835cf6c4.1402387862.git.d.kasatkin@samsung.com>
	 <20140612160346.GG9578@redhat.com>
	 <1402592126.5318.32.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20140612170044.GI9578@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061217-7164-0000-0000-00000267DA4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 13:00 -0400, Vivek Goyal wrote: 
> On Thu, Jun 12, 2014 at 12:55:26PM -0400, Mimi Zohar wrote:
> > On Thu, 2014-06-12 at 12:03 -0400, Vivek Goyal wrote: 
> > > On Tue, Jun 10, 2014 at 11:48:17AM +0300, Dmitry Kasatkin wrote:
> > > > This patch provides kernel parameter to specify owner's key id which
> > > > must be used for trust validate of keys. Keys signed with other keys
> > > > are not trusted.
> > > > 
> > > > Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > > 
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
> > 
> > The shim patches are here
> > http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
> > 
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
> > Right, the current discussion is whether we need an owner trusted
> > keyring or if just one key was enough.  Thanks for chiming in.
> > 
> > The other option would be to sign the bzImage file creating a
> > 'security.ima' extended attribute and verifying it.  Have you created a
> > security kexec hook?
> 
> No, I have not created another hook. As bzImage is already signed it is
> much simpler to verify same signature instead of carrying another set
> of detached signatures and key management etc.

Fin (cc'ed) has patches that include the file signatures in the RPM
header and installs them.  There wouldn't be any need for a separate
detached signature.

Mimi

