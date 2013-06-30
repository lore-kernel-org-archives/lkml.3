Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3F3V1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:27:41 -0400
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:53394
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3F3V1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:27:40 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: trouble building 'perf' for 3.9.7
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <g38s0l697.fsf@dworkin.scrye.com>
Date: Sun, 30 Jun 2013 15:27:28 -0600
In-Reply-To: <g38s0l697.fsf@dworkin.scrye.com> (Anthony Foiani's message of "Sat\, 29 Jun 2013 19\:47\:00 -0600")
Message-ID: <gehbjqofz.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.101 (Gnus v5.10.10) XEmacs/21.5-b33 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings --

I wrote:

> Anyway, this worked fine for 2.6.late, as well as 3.0 stable and 3.4
> stable.  However, I wanted the improvements to 'usbip', so I switched
> to 3.9; currently I'm using 3.9.7.
>
> Using exactly the same scripts (see below), perf now fails to build:

I have to eat some of those words.

I tried switching back to 3.4, and the build still failed.  I'm
mystified, as I thought I had done a full rebuild with that kernel,
but maybe I hadn't (and the build succeeded due to bits left over from
earlier kernels).

The final fix (for 3.4 -- testing with 3.9 now) was to *not* point the
perf build at the target ("staging") headers.  Instead, perf finds the
sysroot headers installed as a part of the cross-compile toolchain.

This left issues with elfutils, but I changed that build step to put
them in a custom subdirectory.  That way, I could configure perf to
use that location without pulling in the sanitized headers.

Sorry if anyone wasted their time chasing down my carelessness.

(Although, to be fair, 'perf' is the only package out of about 20 that
fails when I explicitly point the build at the target's "include"
directory.)

Thanks again!

Best regards,
Anthony Foiani
