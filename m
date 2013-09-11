Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3IKTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:08:46 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:38188 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3IKTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com>
References: <1378920168.26698.64.camel@localhost> <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
 <20130911184509.GB13397@thunk.org> <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Sep 2013 12:08:24 -0700
Message-ID: <CALCETrX0hN5hfW0rAsJ-uAKyV5eVSdhntT0TOVumLm2CDyLLBQ@mail.gmail.com>
Subject: Re: TPMs and random numbers
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, David Safford <safford@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:06 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On Wed, Sep 11, 2013 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> We should definitely do this.  If the TPM driver could fetch some
>> randomness and then call add_device_randomness() to feed this into the
>> random driver's entropy pool when it initializes itself, that would be
>> ***really*** cool.
>
>
> rngd already does this.

And all those random numbers generated before rngd starts are quite
possibly crap.

I think that rngd makes sense as a tool to access strange sources of
entropy and to periodically reseed the pool, but I also think that the
kernel should really be pulling in easily available entropy on its own
at startup.

--Andy
