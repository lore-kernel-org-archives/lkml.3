Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3ICLji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:39:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:53769 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab3ICLjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:39:37 -0400
Date: Tue, 3 Sep 2013 07:39:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11
Message-ID: <20130903113933.GB15457@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
 <5225234A.50407@roeck-us.net>
 <20130903021753.GA15457@thunk.org>
 <1378176973.32763.355.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378176973.32763.355.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 07:56:13PM -0700, Nicholas A. Bellinger wrote:
> 
> Enabling DKIM now, and just waiting for the TXT records to update to
> verify.

The best way to verify is to send your test-email e-mail to GMail, and
then select "Show Original" from the per-message drop-down menu when
you view the message using GMail.  Then look for the
"Authentication-Results" mail header:

Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of tytso@thunk.org designates 2600:3c02::f03c:91ff:fe96:be03 as permitted sender) smtp.mail=tytso@thunk.org;
       dkim=pass header.i=@thunk.org

This will confirm whether or not you got all of the details right.
And note that Google is IPv6-enabled, which means that if you are
using SPF, and your mail server on Rackspace also has IPv6 enabled
(which is likely), do make sure your SPF records includes both its
IPV4 and IPV6 addresses; or else you might be getting an SPF soft- or
hard- fail that could end up marking your mail as possibly being spam,
even if other mail servers which are not IPv6 enabled think it's fine.

Good luck,

						- Ted
