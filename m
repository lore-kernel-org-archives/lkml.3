Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3IKB3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:29:44 -0400
Received: from hurricane.the-brannons.com ([64.62.188.119]:40164 "EHLO
	hurricane.the-brannons.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab3IKB3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:29:43 -0400
From: Chris Brannon <chris@the-brannons.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Raphael S Carvalho <raphael.scarv@gmail.com>, devel@driverdev.osuosl.org,
        Kirk Reiser <kirk@reisers.ca>, speakup@braille.uwo.ca,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
	<87fvtefy10.fsf@mushroom.PK5001Z>
	<CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
	<87y576edm6.fsf@mushroom.PK5001Z> <20130910231228.GF6329@mwanda>
Date: Tue, 10 Sep 2013 18:29:39 -0700
In-Reply-To: <20130910231228.GF6329@mwanda> (Dan Carpenter's message of "Wed,
	11 Sep 2013 02:12:29 +0300")
Message-ID: <878uz4du2k.fsf@mushroom.PK5001Z>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Good eye for spotting the memory corruption bug!
>
> This is a bug fix, so the fix should go in a separate patch and not
> merged with a code cleanup patch.  Ordinary users can trigger this so
> it's a security bug and separating it out is extra important.

Ok.  I just sent up a patch to the driverdev list.  I missed a few
of the Cc's that were on this thread, though.
Also, it will conflict with Raphael's cleanup.

> The checking in spk_set_num_var() is not sufficient as well.  If we use
> E_INC then we can hit an integer overflow bug:

Good catch.  In fact, we shouldn't be using input at all!  Instead, we
need to use the value of the voice parameter after it was changed.  That
will be a valid index into the two tables.  My patch does so.

-- Chris
