Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaHDKEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:04:30 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:33344 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHDKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:04:28 -0400
Date: Mon, 4 Aug 2014 11:04:23 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef
 statement in sg_set_bf
Message-ID: <20140804100423.GY31950@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Nick Krause <xerofoify@gmail.com>,
	Mateusz Guzik <mguzik@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
 <20140803035931.GA24059@mguzik.redhat.com>
 <CAPDOMVh16no_Lh=4cPEpXJheCU67DJJS6EBtg9AH_0yUXxXSPg@mail.gmail.com>
 <20140803050221.GA31553@mguzik>
 <CAPDOMVhmcSqAR413hA8Ro0j2x54snt9Pj5Q_VVQLtea7Xr1jBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzUyxqdXrKJm2YZW"
Content-Disposition: inline
In-Reply-To: <CAPDOMVhmcSqAR413hA8Ro0j2x54snt9Pj5Q_VVQLtea7Xr1jBQ@mail.gmail.com>
X-GPG-Fingerprint: B25A 5A66 69D3 1E15 2DD8  0998 BF73 F4E5 65E7 4AC0
X-GPG-Key: 65E74AC0
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.23 (2014-03-12)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MzUyxqdXrKJm2YZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 03, 2014 at 01:18:45AM -0400, Nick Krause wrote:
> On Sun, Aug 3, 2014 at 1:02 AM, Mateusz Guzik <mguzik@redhat.com> wrote:
> > On Sun, Aug 03, 2014 at 12:31:30AM -0400, Nick Krause wrote:
> >> On Sat, Aug 2, 2014 at 11:59 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
> >> > On Sat, Aug 02, 2014 at 10:56:13PM -0400, Nicholas Krause wrote:
> >> >> This changes the ifdef statement in sg_set_bg to !CONFIG_DEBUG_SG in order
> >> >> to avoid a bug with xhci dequence/enquence functions.
> >> >>
> >> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> >> >> ---
> >> >>  include/linux/scatterlist.h | 2 +-
> >> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> >> >> index adae88f..62de7b3 100644
> >> >> --- a/include/linux/scatterlist.h
> >> >> +++ b/include/linux/scatterlist.h
> >> >> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
> >> >>  static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
> >> >>                             unsigned int buflen)
> >> >>  {
> >> >> -#ifdef CONFIG_DEBUG_SG
> >> >> +#ifdef !CONFIG_DEBUG_SG
> >> >>       BUG_ON(!virt_addr_valid(buf));
> >> >>  #endif
> >> >
> >> > Have you tried compiling this? IIRC you said you would compile your
> >> > stuff, what hapened to that?
> >> >
> >> > What exactly were you trying to achieve? Did this BUG_ON detect a
> >> > problem on your system and now you are trying to silence it?
> >> >
> >> > The change would be wrong even if it compiled since it would just
> >> > execute the assertion only when debug is disabled.
> >> >
> >> > --
> >> > Mateusz Guzik
> >> This is the mailing theme I am getting this from,[xhci] kernel BUG at
> >> include/linux/scatterlist.h:115.
> >> I hope this answers your question about the BUG_ON and yes I did
> >> compile check it with make
> >> M=include/. I also checked usb and usb net directories too.
> >
> > So how have you verified it tests you change? Why didn't you perform a
> > full build?
> >
> > This is a syntax error, I suggest you read up about C preprocessor.
> >
> > Your change attempts to flip the condition. Now virt_addr_valid(buf) is
> > tested only with debug disabled. When you enable debug it is suddenly
> > not tested - definitely does not make sense.
> >
> > I'm assuming you are talking about https://lkml.org/lkml/2014/7/30/810
> >
> > If you actually read the thread you will note:
> >> Looks like I either need specify valid addresses to sg_set_buf(), or
> >> just make the unit test depend on !CONFIG_DEBUG_SG.
> >
> > 1. It is acknowleged the problem is in the caller
> > 2. There is a suggestion to ensure that the UNIT TEST is not executed if
> > CONFIG_DEBUG_SG  is enabled (this part was shortened to "!CONFIG_DEBUG_SG"
> > but nobody claims you can use this in if/if[n]def statements)
> >
> > UNIT TEST as in the thingy which resulted in passing down a buffer
> > failing on this BUG_ON.
> >
> > There is no suggestion to do anything with sg_set_buf itself.
> >
> > You were advised several times to find a simpler project. Also people
> > noted that a "beginner kernel programmer" actually means "seasoned
> > programmer learning the kernel". It is clear you are not a seasoned
> > programmer, so why do you insist on doing kernel work?
> >
> > I can only recommend you play with userspace programs for now. These are
> > much easier to debug and experiment with, not to mention have a lot lower
> > entry point.

> I am really losing my temper with people , when all you do is tell
> me to work on something else and don't even point me to how to build
> test in the kernel tree. Are you stating that your every fucking
> change I have to build the kernel over again, that is a waste of
> time and you known it.

   Yes, that is *exactly* what they are telling you. Every. Single.
Change. You *must* compile your change, *and* test it fully. If the
change touches something to do with hardware, you must have that
hardware to test with. If the change touches a filesystem, the minimum
testing (note: that's *minimum*) you should be doing is running
xfstests. Other subsystems will have their own test suites as well.

   This (compile, and test thoroughly) is *not* a waste of time. It
prevents you wasting everyone else's time, and it ensures that at
least you have some assurance that the code you've written works
properly. Anything else is just lazy and sloppy, and (quite rightly),
nobody wants code by lazy, sloppy programmers in the kernel.

> Please stop telling me I can do this due to a few mistakes that you
> and the other developers are fucking over doing.

   It's not "a few mistakes". You've made a cock-up in pretty much
every single patch I've seen from you. These are sometimes logical
errors like this one -- a few moments thought should have told you
that the change wasn't actually fixing anything. More often, you're
demonstrating *obviously* that you have absolutely no idea about what
the code you've changed should be doing, or what the effect of the
change you've made actually is.

   Many people have tried to tell you, with varying degrees of
helpfulness, verbosity and rudeness, where you are going wrong, and
what things you need to be doing to make yourself a better developer,
and you have pretty much universally ignored them. The reason that you
are being told that you should work on some userspace project is
because the complexity of the code-base is typically lower, there's
less effort involved in understanding the code, and the developers are
sometimes less finicky about code quality (so you can make more
mistakes without people getting cross about it). This would all make
it easier for you to get practice on a large multi-developer project.
Note that doing so would still mean that you have to compile and test
all your changes before you submit them to the developers. You don't
get out of doing that at all.

   In short, the "work" you are doing here on the kernel is
appallingly substandard, and you are giving no indication that you are
learning anything from the people trying to help you. This is why
people are getting angry.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- You shouldn't anthropomorphise computers. They really ---      
                            don't like that.                             

--MzUyxqdXrKJm2YZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99ap1heFHXiqx3kAQLGNg//QwKEf3ot9Eo+GHoSGMpr7ikqojX61KSX
bByWeUNjJOX8HrFimGu2zWkqfHUsmR/y6BSrH1UXDZBQSuevVFrVMY6aWYIYdqhi
ICeOXL59f8l7WszQUZd4XM1YSK6ewejmHu43acOnC34SLbuxokts/Xhf6WARs4CV
F4J66XhqRzLnpJz8zoFxstQMOjnMt1dx7CLJedV5QPYewNOSv0eiVJKDzR+rT2aj
mEigsqY3oDIxDtpgUsWYgA2sAgJ0gXPowJtPrRQxZ7DJpcAIlymDkRxx74gE4mLP
aRindB/yplsXMg6okt0whi8LTWP6uTKrqHi4zT+jI+3rLFys7DrdSIuGtKYL8GO5
/P2CBApOMSfpNeux2qABoC9LBVLwI3ljgCoeKd49pXGj4oUn4aXBZVEbJ7ZgkiJH
BF68Q02tJqiY56tEY326AWMOuJcuassnCw24TJT76U/D2fvYvsucEJOtHaJnzvXf
+qTsZYJZlq0QoN3J+fU4ZV0RbOE1Jr/2ifDWKCsc+vIp51mzYEWMhFypfDCg2GAu
klCeaR61zmJkA4+DVpfZRvMAxuq/wXGRHch4IQbIvzBa4+HKnd0gSIFsrKY2ycG/
3nf6CBe5JUNxISJX6/YxCwFX//WcE5n1TN1f88vyAIO0RE0ZS6RqHQlqtWyhUxuC
VXAdVUxRh/8=
=77ok
-----END PGP SIGNATURE-----

--MzUyxqdXrKJm2YZW--
