Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab3CSXAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:00:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40494 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757207Ab3CSXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:00:35 -0400
Message-ID: <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 23:00:31 +0000
In-Reply-To: <20130319185003.GA13301@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
	 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
	 <20130319163531.GA10879@srcf.ucam.org>
	 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
	 <20130319172506.GA11969@srcf.ucam.org>
	 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
	 <20130319182810.GA13003@srcf.ucam.org>
	 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
	 <20130319185003.GA13301@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 18:50 +0000, Matthew Garrett wrote:
> On Tue, Mar 19, 2013 at 06:40:56PM +0000, James Bottomley wrote:
> > On Tue, 2013-03-19 at 18:28 +0000, Matthew Garrett wrote:
> > > It requires the key to survive the system being entirely powered down, 
> > > which means it needs to be BS+NV. It shouldn't be possible for userspace 
> > > to access this key.
> > 
> > It requires the *public* key to survive power down, certainly.  The
> > private key can be thrown away once the hibernate image is signed.  I
> > think the scheme can be constructed so the private key is never in NV
> > storage ... that also makes it more secure against tampering.
> 
> Well, that somewhat complicates implementation - we'd be encrypting the 
> entire contents of memory except for the key that we're using to encrypt 
> memory. Keeping the public key away from userspace avoids having to care 
> about that.

I don't quite understand what you're getting at: the principle of public
key cryptography is that you can make the public key, well public.  You
only need to guard the private key.

James



