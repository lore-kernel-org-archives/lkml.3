Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3J1PLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab3J1PLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:11:36 -0400
Message-ID: <526E7E85.2000009@redhat.com>
Date: Mon, 28 Oct 2013 11:11:01 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        tigran@aivazian.fsnet.co.uk, x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH] x86, microcode, Fix long microcode load time when firmware
 file is missing [v2]
References: <1382961968-20067-1-git-send-email-prarit@redhat.com> <20131028143714.GL4314@pd.tnic> <20131028150656.GA15440@khazad-dum.debian.net>
In-Reply-To: <20131028150656.GA15440@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/2013 11:06 AM, Henrique de Moraes Holschuh wrote:
> On Mon, 28 Oct 2013, Borislav Petkov wrote:
>> So Prarit, please split this patch into changes which *directly* address
>> the issue and other cleanups ontop. This will simplify review immensely
>> as having one single bulky patch is not easy on the eyes.
>>
>> Then, make sure to audit the lowlevel drivers whether they're already
>> issuing output on the error path before adding new printks arbitrarily.
> 
> Something else I couldn't check just from the description (and I apologise,
> but I did not look at your patch closely enough to check how you implemented
> the functionality on Intel): in the general case, it is NOT acceptable to
> bail out if you cannot find the firmware for the first processor.
> Mixed-stepping systems do exist, and you might need to update the microcode
> of, e.g, just the third processor.
> 
> AMD can get away with a half-done implementation of negative caching (or an
> "optimised one" depending on your PoV :) ) because they have per-family
> firmware files, so even mixed-stepping systems will require only the same
> file.  This is *not* true for Intel, which is really annoying.

Is that right? :(  I took Andi's comment to imply otherwise ...  If that's the
case then, yeah, back to the drawing board with this.

Andi (or anyone from Intel) -- care to offer a comment?

P.
> 
