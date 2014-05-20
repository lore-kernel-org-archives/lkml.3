Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaETUJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:09:47 -0400
Received: from longford.logfs.org ([213.229.74.203]:43359 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaETUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:09:44 -0400
Date: Tue, 20 May 2014 16:08:03 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140520200803.GA22308@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <8761l0r6nc.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8761l0r6nc.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 05:12:07 -0700, Andi Kleen wrote:
> Jörn Engel <joern@logfs.org> writes:
> >
> > An alternate high-resolution timer is the register content at the time
> > of an interrupt. 
> 
> So if you interrupt a cryptographic function you may hash in parts
> of the key?

Yes.  And if there was an efficient way to deduce random generator
inputs, that would be a new side channel attack.  An efficient way to
deduce random generator inputs would allow many other attacks as well.
I don't know of such an attack nor can I conceive it being possible
under normal circumstances.

There are of course two exceptions.  If the attacker can read
arbitrary kernel memory - and therefore could read the private key
directly.  And if there is so little entropy that an attacker can
enumerate all possible states of the random generator and read enough
random numbers to exclude most of those states.

The second case also allows for many more interesting attacks and is
exactly the sort of hole I want to plug with this patch.

I think leaking of private keys or similar information is not a
concern.  But please prove me wrong.  Better you now than someone else
later.

Jörn

--
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
