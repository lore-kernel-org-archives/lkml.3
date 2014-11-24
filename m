Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKXNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:43:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40562 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKXNnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:43:14 -0500
Message-ID: <1416836587.25352.24.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/5] PKCS#7: Allow detached data to be supplied for
 signature checking purposes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 08:43:07 -0500
In-Reply-To: <14157.1416833305@warthog.procyon.org.uk>
References: <1416829928.25352.6.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165425.5264.24661.stgit@warthog.procyon.org.uk>
	 <14157.1416833305@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0029-0000-0000-000005D2B4FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 12:48 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Ok, PCKS#7 supports detached data.  I assume this is not needed for
> > kernel modules.  What is the motivation for adding this support to the
> > kernel?
> 
> See patch #5.  I should probably note that in the commit message.

This patch set does not change the syscall.  The signature is still
appended to the kernel module.  In fact, the call from
kernel/module_signing.c: mod_verify_pkcs7() calls
pkcs7_supply_detached_data() with a pointer to the module and the module
length to set the data field. pkcs7_supply_detached_data() would not be
defined or exported, unless it was going to be called elsewhere.  How
else are you planning on using pkcs7_supply_detached_data()? 

Mimi


