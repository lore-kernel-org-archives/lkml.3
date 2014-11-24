Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaKXO7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:59:34 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55586 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKXO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:59:32 -0500
Message-ID: <1416841165.25352.42.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/5] PKCS#7: Allow detached data to be supplied for
 signature checking purposes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 09:59:25 -0500
In-Reply-To: <26417.1416840116@warthog.procyon.org.uk>
References: <1416836587.25352.24.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1416829928.25352.6.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165425.5264.24661.stgit@warthog.procyon.org.uk>
	 <14157.1416833305@warthog.procyon.org.uk>
	 <26417.1416840116@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112414-0017-0000-0000-00000687BEAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 14:41 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > > Ok, PCKS#7 supports detached data.  I assume this is not needed for
> > > > kernel modules.  What is the motivation for adding this support to the
> > > > kernel?
> > > 
> > > See patch #5.  I should probably note that in the commit message.
> > 
> > This patch set does not change the syscall.  The signature is still
> > appended to the kernel module.
> 
> Ummm, yes, so?
> 
> > In fact, the call from kernel/module_signing.c: mod_verify_pkcs7() calls
> > pkcs7_supply_detached_data() with a pointer to the module and the module
> > length to set the data field. pkcs7_supply_detached_data() would not be
> > defined or exported, unless it was going to be called elsewhere.  How else
> > are you planning on using pkcs7_supply_detached_data()?
> 
> Is your point that I exported it unnecessarily?  That I have now fixed.

No, it was more a comment on the function name
pkcs7_supply_detached_data() being a bit weird, as the signature is
appended to the data.

Mimi

