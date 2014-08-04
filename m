Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaHDKHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:07:21 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:33368 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHDKHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:07:20 -0400
Date: Mon, 4 Aug 2014 11:07:17 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef
 statement in sg_set_bf
Message-ID: <20140804100717.GZ31950@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Nick Krause <xerofoify@gmail.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
 <53DE2AEF.6080904@cogentembedded.com>
 <CAPDOMVgTNSTzXENWZvWhuJvHRoPBRBYSExNxrwqeFGyQ44YA-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWAbeGC4mMoqIxdF"
Content-Disposition: inline
In-Reply-To: <CAPDOMVgTNSTzXENWZvWhuJvHRoPBRBYSExNxrwqeFGyQ44YA-w@mail.gmail.com>
X-GPG-Fingerprint: B25A 5A66 69D3 1E15 2DD8  0998 BF73 F4E5 65E7 4AC0
X-GPG-Key: 65E74AC0
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.23 (2014-03-12)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWAbeGC4mMoqIxdF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 03, 2014 at 01:30:44PM -0400, Nick Krause wrote:
> On Sun, Aug 3, 2014 at 8:28 AM, Sergei Shtylyov
> > On 03-08-2014 6:56, Nicholas Krause wrote:
> >
> >> This changes the ifdef statement  in sg_set_bg to !CONFIG_DEBUG_SG in
> >> order
> >> to avoid a bug with xhci dequence/enquence functions.
> >
> >
> >    dequeue/enqueue?
> >
> >
> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> >> ---
> >>   include/linux/scatterlist.h | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >
> >> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> >> index adae88f..62de7b3 100644
> >> --- a/include/linux/scatterlist.h
> >> +++ b/include/linux/scatterlist.h
> >> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist
> >> *sg)
> >>   static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
> >>                               unsigned int buflen)
> >>   {
> >> -#ifdef CONFIG_DEBUG_SG
> >> +#ifdef !CONFIG_DEBUG_SG
> >
> >
> >    Didn't you mean #ifndef instead? I guess you didn't even try to
> > build-test this.
> >
> >
> >>         BUG_ON(!virt_addr_valid(buf));
> >>   #endif
> >>         sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> >
> >
> > WBR, Sergei
> >
> I am going to stay around and learn more but am going to check my
> patches better as this is
> my fault.

   This is something like the fourth time you've said this, and you
still haven't managed to do it. :(

   Compile the code. Every. Single. Time.

   Test the code. Every. Single. Time.

   Not optional, not negotiable.

   Hugo.

> Regards Nick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---    
                         money? There's irony...                         

--uWAbeGC4mMoqIxdF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU99bVVheFHXiqx3kAQJhBw//Qwkf0CsQyi0xZTD4HvmHaDpLdBkBVFMc
Y91TC4x0HhlE1Vio6tNEXXgPRyzZKXB9wrQ8N3g8dDLrSvtq61WrhN41fCFvNs51
3Xj2PPEvSf4FGr7XwLdv5PZoYAU6GL/2B17Vdw4ZrdVqvULnCygEfVDvVD6oOFJr
3wsFNOKkdyce1AvWnYGCSV4vOmT9gXDCD1+8Xn0br0PiVWsKSoP8tyjqafv7yOrH
fhO+cU/g8krRn+FZl5ew576bGE11HA3L3tvWAytHjfN+9lTPGPpKXYn2a+tpcnu7
tOErllpDdssaxj+du/WVXAz7i96wyZdGNyGO5q7B8eppUJvwyltZmPi0EBYXyugD
4jWZOjz9vD99c+V1D5bd8FeXxcbQFqQgmyVuoNWMYs6jIpZo4STH1r93iYejNQuj
mpElWZjnF0fdCEL/MDXC9A7Sh3B0/H5Um+ZsntWDWHYNY6VSEi5esLVHYsv094mO
r+eSMaXydiS4vmto9V7vmADTGKk6TqmUWdPciOijU6g/y27orHg5GTzGlE4+NYXm
4A0roUXBhQnQrGGMj/KFg78nhmoZkFia8kW5uq/y8OtnfuxGGWvDVUL7WBw8ujuC
E1EBzdYo6PHli96LMxQGAQVIDXx/yuHcPTevE+obPoSq1pk3RbBzjHtrObPgKULO
ylx0460okrI=
=p1/Q
-----END PGP SIGNATURE-----

--uWAbeGC4mMoqIxdF--
