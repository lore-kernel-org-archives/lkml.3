Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3AUAqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:46:46 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:61758 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUAqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:46:45 -0500
Date: Sun, 20 Jan 2013 19:46:44 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Dillow <dave@thedillows.org>
Message-ID: <1675719618.94034.1358729204255.JavaMail.root@elliptictech.com>
In-Reply-To: <8b7b5c2c-1e9f-4390-8492-a21cf8566d55@email.android.com>
Subject: Re: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
> To: "Tom St Denis" <tstdenis@elliptictech.com>, "David Dillow" <dave@thedillows.org>
> Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
> Sent: Sunday, 20 January, 2013 3:30:49 PM
> Subject: Re: IPsec AH use of ahash
> 
> Look at it from the kernel end. What happens if your change shows up
> bugs on another architecture or has a flaw. It works for you now but
> you plan to dump and run. That's not a viable long term development
> model for upstream.

Alan, I'm really not trying to be rude but if you look at the depth of the patch I was submitting ... it's not architecture specific, it's 90% copied from another source file that is currently in the tree, I have actually tested it on x86_32/arm already as it is, etc.  I agree that more core pieces of architecture specific code would require tighter scrutiny but this is hardly the case here. 

> The licence allows you to do it, and other parties who care more to
> pick it up and run with it. Unless someone does however it's just a
> burden. If nobody wants it upstream enough better it stays out
> perhaps - if the call is wrong eventually other people will care
> enoug to share the work. If not you get to pick between doing the
> extra or re-porting your code to new releases

Realistically, the CryptoAPI maintainers should have added CMAC long ago.  I mean they sought fit to add non-standard modes like VMAC or Serpent [or Twofish or ...] but not a NIST standard like CMAC which is used in RFCs for IPsec [among other things]?  Are they writing crypto for Kernel users or is this their pet project where they get to hack together random bits of ciphering what not for their own amusement?

Sure few people are clamouring to use CMAC over say HMAC for MAC generation but it is a standard and it's prevalent enough that supporting it is a good idea.

Forcing me to go through a new testing cycle just because you'd prefer

if (expr)
   foo;

Instead of 

if (expr) {
   foo;
}

or 

err = expr;
if (err) ...

instead of 

if ((err = expr)) ...

is not a good use of anyones time.  And it's hypocritical given that I sourced that coding style from code that is already in the kernel.

Tom
