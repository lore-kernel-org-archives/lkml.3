Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3ILXsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:48:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:60243 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3ILXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:48:49 -0400
Date: Thu, 12 Sep 2013 18:13:40 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Safford <safford@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
Message-ID: <20130912221340.GG3809@logfs.org>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost>
 <20130912215718.GF3809@logfs.org>
 <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 September 2013 19:39:47 -0400, Jeff Garzik wrote:
> On Thu, Sep 12, 2013 at 5:57 PM, Jörn Engel <joern@logfs.org> wrote:
> > On Wed, 11 September 2013 14:47:04 -0400, David Safford wrote:
> >> But I also think that the existing (certified) TPMs are good enough
> >> for direct use.
> 
> > That is equivalent to trusting the TPM chip not to be malicious.  It
> 
> Indeed.  While it need not be rngd or userland at all, it seems
> reasonable to require any hardware RNG to have its data pushed through
> AES mix steps (as kernel random does now IIUC).

*shrug*

The hardware RNG is either providing good entropy or entirely
predictable data - without us being able to tell the difference.  So I
am torn between two extremes.  Either we admit it to the entropy pool
and mix it will all other sources - hoping that it actually is
unpredictable to The Bad Guys(tm).  Or we disregard all of it.

If we disregard all of it, that forces us to collect good entropy from
other sources.  Having what looks like good entropy but may not be
will a) make us complacent and b) make it hard to notice when our
random numbers are compromised.  It is the same strategy as burning
down the bridge, forcing your army to win or die.  It also shares the
same drawbacks.

Jörn

--
"Error protection by error detection and correction."
-- from a university class
