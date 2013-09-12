Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3ILXio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:38:44 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:52655 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3ILXik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:38:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130912215718.GF3809@logfs.org>
References: <1378920168.26698.64.camel@localhost> <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost> <20130912215718.GF3809@logfs.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Sep 2013 16:38:19 -0700
Message-ID: <CALCETrUMtrjHKkxdAEPmkkFG-ZWGZOf450cCP704Dv8mV6sxBA@mail.gmail.com>
Subject: Re: TPMs and random numbers
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: David Safford <safford@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Ted Ts'o" <tytso@mit.edu>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 2:57 PM, Jörn Engel <joern@logfs.org> wrote:
> On Wed, 11 September 2013 14:47:04 -0400, David Safford wrote:
>>
>> But I also think that the existing (certified) TPMs are good enough
>> for direct use.
>
> That is equivalent to trusting the TPM chip not to be malicious.  It
> requires trusting the chip designer, trusting every single employee of
> the chip designer, as some of them may be plants from a random
> countries spook organization, trusting the fab where the chip was
> manufactured, trusting your local dealer not to replace one chip with
> another in a similar packaging, trusting third-party components the
> designers may have incorporated, trusting intermediate steps between
> designer and fab or fab and local dealer, trusting your own employees,
> etc.

I would argue that any TPM-using kernel code should go even further
than just not trusting its RNG.  We should be further wrapping the
TPM-generated keys so that even a complete leak of the SRK wouldn't
allow an adversary to unwrap the keys.

Of course, without blinded operations (which the TPM doesn't support),
we're always vulnerable to the TPM actively leaking private key bits,
but that seems less likely.

(I have a partial implementation of this called tpmkey -- some day I
hope to finish it.)

--Andy
