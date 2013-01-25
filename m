Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3AYMXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:23:47 -0500
Received: from mail.atsec.com ([195.30.99.214]:48069 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab3AYMXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:23:45 -0500
Message-ID: <51027950.2080209@atsec.com>
Date: Fri, 25 Jan 2013 13:23:44 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: David Howells <dhowells@redhat.com>, Kyle McMartin <kyle@redhat.com>,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
References: <20130124190610.GI6538@redacted.bos.redhat.com> <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <9620.1359072894@warthog.procyon.org.uk> <20130125032007.GA15926@srcf.ucam.org>
In-Reply-To: <20130125032007.GA15926@srcf.ucam.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2013 04:20:07, +0100, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

Hi Matthew,
> On Fri, Jan 25, 2013 at 12:14:54AM +0000, David Howells wrote:
> 
>> You can't rely on someone trying to sneak a dodgy crypto module in to set the
>> flag when they build it.  The detection thus needs to be done in the kernel
>> during the module load.
>>
>> Can you search the module image for "crypto_register_" I wonder?  If that's
>> there, it's a crypto module.
> 
> If you're trying to protect against malice rather than accident, what's 
> going to stop the module from just finding and modifying data structures 
> itself? If you want to panic if you've just loaded something that might 
> compromise your crypto implementations, you've got to panic on all 
> unsigned module loads.

That is the issue here. We want to protect against accidental changes
and modifications. Malicious attacks will never be caught by the FIPS
requirements where a module is allowed to check itself.

If an attacker is able to load any kind of kernel module, we have lost.
Period.

Thus, from a FIPS point of view the latest patch from Kyle is also
appropriate, provided the concerns I raised there are covered.

Ciao
Stephan
