Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3IKT3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:29:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab3IKT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:29:43 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrX0hN5hfW0rAsJ-uAKyV5eVSdhntT0TOVumLm2CDyLLBQ@mail.gmail.com>
References: <1378920168.26698.64.camel@localhost> <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com> <20130911184509.GB13397@thunk.org> <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com> <CALCETrX0hN5hfW0rAsJ-uAKyV5eVSdhntT0TOVumLm2CDyLLBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: TPMs and random numbers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 11 Sep 2013 12:25:48 -0700
To: Andy Lutomirski <luto@amacapital.net>, Jeff Garzik <jgarzik@pobox.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, David Safford <safford@us.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Message-ID: <41ba2dff-12ed-4127-acbd-ae5b40e38afd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This of course has been a long-running debate.  Similarly, we could make much better use of RDRAND if instead of doing data reduction in rngd we could feed it to the pool and just credit fractional bits.  The FIPS tests that rngd runs are weak and obsoleted, but perhaps better than nothing (now when we don't shut down rngd due to false positives.)

Andy Lutomirski <luto@amacapital.net> wrote:
>On Wed, Sep 11, 2013 at 12:06 PM, Jeff Garzik <jgarzik@pobox.com>
>wrote:
>> On Wed, Sep 11, 2013 at 2:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> We should definitely do this.  If the TPM driver could fetch some
>>> randomness and then call add_device_randomness() to feed this into
>the
>>> random driver's entropy pool when it initializes itself, that would
>be
>>> ***really*** cool.
>>
>>
>> rngd already does this.
>
>And all those random numbers generated before rngd starts are quite
>possibly crap.
>
>I think that rngd makes sense as a tool to access strange sources of
>entropy and to periodically reseed the pool, but I also think that the
>kernel should really be pulling in easily available entropy on its own
>at startup.
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
