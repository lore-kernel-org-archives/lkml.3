Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbaCSOGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:06:25 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3137 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933380AbaCSOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:06:20 -0400
Message-ID: <1395237927.12633.29.camel@thorin>
Subject: Re: [PATCH] Coccicheck: Remove memcpy to struct assignment test
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, mmarek@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreea Bernat <bernat.ada@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        kernel-janitors@vger.kernel.org
Date: Wed, 19 Mar 2014 15:05:27 +0100
In-Reply-To: <CA+MoWDoSYu-aSp39vBe7DmayH2iqagHNYP9BC7LefajMXk+FnQ@mail.gmail.com>
References: <1395177092-3023-1-git-send-email-peter.senna@gmail.com>
	 <1395230578.12633.21.camel@thorin>
	 <CA+MoWDoSYu-aSp39vBe7DmayH2iqagHNYP9BC7LefajMXk+FnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at 1290; Body=11 Fuz1=11
	Fuz2=11
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.1 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mit, 2014-03-19 at 14:39 +0100, Peter Senna Tschudin wrote:
> On Wed, Mar 19, 2014 at 1:02 PM, Bernd Petrovitsch
> <bernd@petrovitsch.priv.at> wrote:
> > On Die, 2014-03-18 at 22:11 +0100, Peter Senna Tschudin wrote:
> >> The Coccinelle script scripts/coccinelle/misc/memcpy-assign.cocci look
> >> for opportunities to replace a call to memcpy by a struct assignment.
> >> This patch removes memcpy-assign.cocci as it is not clear that this
> >> convention has an impact on the generated code.
> >
> > Using struct assignment keeps the type check and is just for this reason
> > always preferable over memcpy().
> What about the assignment hiding that a potentially large memcpy is
> happening instead of just a pointer assignment?

It makes no difference if you copy 2KB with a struct assignment or with
a memcpy(). IMHO most probably each and every C compiler produces the
same code for both cases.

And - more important - I assume that people which actually read the code
(to understand the code) also know if the variables there are
pointers/ints or a (somewhat large) struct (if only one see an field
access in the struct, it should be pretty clear).
I don't think it makes actually much sense trying to read source without
that ....

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

