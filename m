Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3ILXvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:51:38 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64592 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3ILXvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130912221340.GG3809@logfs.org>
References: <1378920168.26698.64.camel@localhost> <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <1378925224.26698.90.camel@localhost> <20130912215718.GF3809@logfs.org>
 <CAFtxgO5dzJJvFR2tz2Cztvp9rkkyFevfsPxnnOF-q731W8JDxA@mail.gmail.com> <20130912221340.GG3809@logfs.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Sep 2013 16:51:15 -0700
Message-ID: <CALCETrWp_QSstE1NB_bB6uWLEJNcT5NmcuK9MRRQjmGFpy6b=w@mail.gmail.com>
Subject: Re: TPMs and random numbers
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Safford <safford@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 3:13 PM, Jörn Engel <joern@logfs.org> wrote:
> On Thu, 12 September 2013 19:39:47 -0400, Jeff Garzik wrote:
>> On Thu, Sep 12, 2013 at 5:57 PM, Jörn Engel <joern@logfs.org> wrote:
>> > On Wed, 11 September 2013 14:47:04 -0400, David Safford wrote:
>> >> But I also think that the existing (certified) TPMs are good enough
>> >> for direct use.
>>
>> > That is equivalent to trusting the TPM chip not to be malicious.  It
>>
>> Indeed.  While it need not be rngd or userland at all, it seems
>> reasonable to require any hardware RNG to have its data pushed through
>> AES mix steps (as kernel random does now IIUC).
>
> *shrug*
>
> The hardware RNG is either providing good entropy or entirely
> predictable data - without us being able to tell the difference.  So I
> am torn between two extremes.  Either we admit it to the entropy pool
> and mix it will all other sources - hoping that it actually is
> unpredictable to The Bad Guys(tm).  Or we disregard all of it.

Supposedly, the Linux entropy pool has the property that mixing in
even actively malicious data is no worse than not mixing in anything
at all.

(This is probably not true if the so-called entropy can depend on the
current (secret) state of the pool, but the TPM has no way to see
that.)

--Andy
