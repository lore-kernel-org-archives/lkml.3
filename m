Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3LTJlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:41:39 -0500
Received: from mx0.aculab.com ([213.249.233.131]:43692 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755547Ab3LTJlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:41:36 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
Date: Fri, 20 Dec 2013 09:40:01 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74BC@saturn3.aculab.com>
In-Reply-To: <20131219183529.GB17741@jtriplet-mobl1>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/7] drivers: usb: Include appropriate header file in hcd.c
Thread-Index: Ac786Oq4tPi6gz4yRhGrahRSylXysgAfSlsQ
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com> <20131219163623.GB12255@kroah.com> <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com> <20131219165802.GA27639@kroah.com> <AE90C24D6B3A694183C094C60CF0A2F6026B74B9@saturn3.aculab.com> <20131219183529.GB17741@jtriplet-mobl1>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Josh Triplett" <josh@joshtriplett.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rashika Kheria" <rashika.kheria@gmail.com>,
        "Linux-Kernel" <linux-kernel@vger.kernel.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Matthias Beyer" <mail@beyermatthias.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "linux-usb" <linux-usb@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Josh Triplett
> On Thu, Dec 19, 2013 at 05:33:09PM -0000, David Laight wrote:
> > OTOH just including extra headers isn't ideal - it can considerably
> > slow down the compilation time. There are many subsystems that don't
> > really separate their internal headers from their external ones.
> 
> There's a benefit to doing so, though: it ensures that the prototypes in
> the header stay in sync with the definition.

I think you misunderstood what I was saying.
The header with the function prototypes has to be included when the
driver itself is built - there is a gcc warning for that as well.

The 'problem' is that if I only have:
    void foo(struct foo *);
then the C language (uselessly) scopes the declaration of 'struct foo'
to the inside of the functions - making it almost impossible to call.

All you need is an outer declaration:
    struct foo;
    void foo(struct foo *);
what you don't need is the actual definition of 'struct foo'.
Source files that need to look at the members of the structure
should be directly including the header that defines the structure.

Adding nested includes just makes it more likely that code will fail
to directly include the headers that define the structures it uses.

	David



