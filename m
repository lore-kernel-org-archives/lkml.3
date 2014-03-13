Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaCMQkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:40:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44369 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaCMQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:40:06 -0400
Message-ID: <1394728800.8457.48.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: RFC: 'ioctl' for keyrings
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, dmitry.kasatkin@gmail.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2014 12:40:00 -0400
In-Reply-To: <22093.1394727459@warthog.procyon.org.uk>
References: <21625.1394725646@warthog.procyon.org.uk>
	 <22093.1394727459@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031316-8236-0000-0000-000000BE99B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 16:17 +0000, David Howells wrote: 
> David Howells <dhowells@redhat.com> wrote:
> 
> > I can fix this in one of a number of ways:
> > 
> >  (1) Provide a generic control operation (analogous with ioctl()) that allows
> >      the user to make some general operation on a key (querying it, altering
> >      it, interacting with hardware).
> > 
> >  (2) Provide an alter operation that only allows the key to be altered.
> >      Looking at trusted_update(), though, I have a suspicion that this may not
> >      be sufficient as that also seems to invoke an interaction with the TPM.
> > 
> >  (3) Provide separate, specific keyctl functions for the special operations
> >      required by encrypted and trusted keys (and other key types potentially)
> >      that are then validated in the core and routed to the key type.
> 
>   (4) Simply make key_update() look for the encrypted and trusted key types
>       and call a special key type op for those.  The main ->update op will be
>       taking preparsed data and would no longer be callable in this situation.

I prefer this last option. Define a separate 'update' option for trusted
and encrypted keys, which would only create or modify, but never replace
an existing key.

thanks,

Mimi

