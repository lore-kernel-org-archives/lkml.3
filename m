Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaCNRxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:53:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43688 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbaCNRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:53:19 -0400
Message-ID: <1394819594.2657.6.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: RFC: 'ioctl' for keyrings
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, dmitry.kasatkin@gmail.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Safford <safford@us.ibm.com>
Date: Fri, 14 Mar 2014 13:53:14 -0400
In-Reply-To: <7511.1394817275@warthog.procyon.org.uk>
References: <1394729834.8457.58.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <21625.1394725646@warthog.procyon.org.uk>
	 <7511.1394817275@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031417-3532-0000-0000-00000050F9D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 17:14 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > As I understand the code, I think operations being performed from ->update()
> > > are:
> > > 
> > >  (a) Resealing a key with a new pcrs (trusted).
> > > 
> > >  (b) Changing the master key (encrypted).
> > > 
> > > Mimi, Dmitry: is this list right?
> > 
> > In addition to resealing trusted keys to a new TPM PCR value, there are
> > a few other options that can be modified (eg. keyauth, blobauth,
> > pcrlock).  Encrypted keys can be encrypted/decrypted with a new master
> > key (trusted or user key type).
> 
> Can (re)sealing a key be viewed as encrypting it?  Is the difference between
> sealing a key and encrypting a key the use of hardware support?

Yes, 'resealing/sealing' is TPM terminology for encrypting/decrypting.
The sealing is RSA encryption by a TPM chip, which can only be decrypted
by the same chip.

Mimi

