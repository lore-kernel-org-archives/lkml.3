Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3AQWST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:18:19 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:59153 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3AQWSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:18:18 -0500
X-Greylist: delayed 3428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 17:18:16 EST
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358449049.2689.87.camel@falcor1>
References: <1358449049.2689.87.camel@falcor1> <20130117180352.27885.79893.stgit@warthog.procyon.org.uk> <20130117180400.27885.2973.stgit@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/3] KEYS: Separate the kernel signature checking keyring from module signing
X-Mailer: MH-E 8.3.1; nmh 1.5; GNU Emacs 24.1.50
Date: Thu, 17 Jan 2013 21:20:28 +0000
Message-ID: <30183.1358457628@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Lets assume accepting built in keys should is acceptable for all use
> cases.  Adding additional keys from userspace is probably not acceptable
> for all use cases.  Those keys should be added to specific 'trusted'
> keyrings.
> 
> EVM and IMA-appraisal have separate keyrings for this reason.  I might
> be interested in allowing third party packages to be installed and
> executed, but that doesn't imply that a security.evm extended attribute,
> signed by a third party application, is acceptable.

We should probably look at using the capability of X.509 certificates to
indicate what a key may be used for and noting that in the public_key struct.

David
