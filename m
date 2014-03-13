Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaCMQRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaCMQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:17:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <21625.1394725646@warthog.procyon.org.uk>
References: <21625.1394725646@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: RFC: 'ioctl' for keyrings
Date: Thu, 13 Mar 2014 16:17:39 +0000
Message-ID: <22093.1394727459@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I can fix this in one of a number of ways:
> 
>  (1) Provide a generic control operation (analogous with ioctl()) that allows
>      the user to make some general operation on a key (querying it, altering
>      it, interacting with hardware).
> 
>  (2) Provide an alter operation that only allows the key to be altered.
>      Looking at trusted_update(), though, I have a suspicion that this may not
>      be sufficient as that also seems to invoke an interaction with the TPM.
> 
>  (3) Provide separate, specific keyctl functions for the special operations
>      required by encrypted and trusted keys (and other key types potentially)
>      that are then validated in the core and routed to the key type.

  (4) Simply make key_update() look for the encrypted and trusted key types
      and call a special key type op for those.  The main ->update op will be
      taking preparsed data and would no longer be callable in this situation.

David
