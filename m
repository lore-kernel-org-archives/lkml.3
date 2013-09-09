Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3IIEHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:07:30 -0400
Received: from hurricane.the-brannons.com ([64.62.188.119]:39950 "EHLO
	hurricane.the-brannons.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab3IIEH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:07:28 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 00:07:28 EDT
From: Chris Brannon <chris@the-brannons.com>
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>, Kirk Reiser <kirk@reisers.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
Date: Sun, 08 Sep 2013 20:56:43 -0700
In-Reply-To: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
	(Raphael S. Carvalho's message of "Mon, 2 Sep 2013 19:20:18 -0300")
Message-ID: <87fvtefy10.fsf@mushroom.PK5001Z>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Raphael S.Carvalho" <raphael.scarv@gmail.com> writes:

> +             /*
> +		* If voice was just changed, we might need to reset our default
> +		* pitch and volume.
> +		*/
> +		if (param->var_id == VOICE) {
> +			spk_reset_default_value("pitch", synth->default_pitch,
> +				value);
> +			spk_reset_default_value("vol", synth->default_vol,
> +				value);

There's an "invalid read" bug here.  You didn't introduce it; it has
been there all along.  It's possible that value contains a value that is
out of range, in which case, the spk_reset_default_value calls could
fetch invalid data.  The value of ret should be sufficient for
determining whether value is in range, so I'd change the condition of
the if statement to this:

		if (param->var_id == VOICE && ret != -ERANGE) {

Or possibly better:
		if (param->var_id == VOICE && ret == 0) {

I'd say please resend with that fix, or if not, I can send a one-line
patch to be applied after yours.

-- Chris
