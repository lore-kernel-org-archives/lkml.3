Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3KRUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:06:01 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46957 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3KRUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:05:58 -0500
Message-ID: <1384805151.5181.82.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 5/6] ima: do not include field length in template digest
 calc for ima template
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ima-devel@lists.sourceforge.net, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, james.l.morris@oracle.com
Date: Mon, 18 Nov 2013 15:05:51 -0500
In-Reply-To: <CACE9dm8n2fyOuMcgVM7NGpptP-G9WhHnh-NR0bsTQO4bG3XCuQ@mail.gmail.com>
References: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
	 <1384523146-9290-6-git-send-email-roberto.sassu@polito.it>
	 <CACE9dm9CjjLkv4oh7vpm=AiHSRfuouEkOrMaRpv3EA_c1_LO=A@mail.gmail.com>
	 <1384789840.5181.76.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm8n2fyOuMcgVM7NGpptP-G9WhHnh-NR0bsTQO4bG3XCuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111820-9332-0000-0000-0000023251ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 21:40 +0200, Dmitry Kasatkin wrote:
> On Mon, Nov 18, 2013 at 5:50 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Mon, 2013-11-18 at 17:30 +0200, Dmitry Kasatkin wrote:
> >> On Fri, Nov 15, 2013 at 3:45 PM, Roberto Sassu <roberto.sassu@polito.it> wrote:
> >
> >> > @@ -160,12 +161,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
> >> >                 return rc;
> >> >
> >> >         for (i = 0; i < num_fields; i++) {
> >> > -               rc = crypto_shash_update(&desc.shash,
> >> > -                                        (const u8 *) &field_data[i].len,
> >> > -                                        sizeof(field_data[i].len));
> >> > -               if (rc)
> >> > -                       break;
> >> > -
> >> > +               if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> >> > +                       rc = crypto_shash_update(&desc.shash,
> >> > +                                               (const u8 *) &field_data[i].len,
> >> > +                                               sizeof(field_data[i].len));
> >> > +                       if (rc)
> >> > +                               break;
> >> > +               }
> >>
> >> What was actually the point in including field length in the hash calculation?
> >> Does it really make it cryptographically stronger?
> >> If not then remove it at all...
> >
> > We should be able to walk the measurement list without needing to
> > understand template specific data.  All of the template data, including
> > the field lengths, needs to be included in the template hash.
> >
> 
> Sorry, how adding field length helps walking measurement list?
> It makes it even more tricky...

The new template architecture adds sending the field length.

> Previously, I could calculate the hash over the whole template data
> from binary_measurement_list to get template hash.

> Now every field must be processed separately to get template hash...

You still calculate the template hash based on the entire template data,
including the lengths.  Without including the lengths in the hash
calculation, you would need to parse the individual template field
data. 

Mimi

