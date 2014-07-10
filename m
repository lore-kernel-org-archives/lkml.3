Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaGJLmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:42:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46202 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaGJLmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:42:32 -0400
Date: Thu, 10 Jul 2014 13:42:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140710114222.GE2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
 <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-edac.

On Wed, Jul 09, 2014 at 02:24:31PM -0700, Havard Skinnemoen wrote:
> > > The CMCI poll interval was updated to pick the minimum interval between
> > > the original 30 seconds and the check_interval divided by 8 (minimum of
> > > 3 polls).
> >
> > Why min 3 polls? How do you come up with exactly that frequency?
> 
> The idea is that if we make it equal to check_interval, it might
> bounce back and forth a lot. So we need to divide by something, and 8
> seems like a nice, safe value, and it seems to work well. We're not
> opposed to considering other values, of course (e.g. 2 and 4 might
> work well too, but with somewhat higher risk of ping-ponging).

Yep, this is exactly why I'm asking about your use case. Because if we
set it to any number, someone down the line will appear and say that
this doesn't suit her/his needs.

So, I'm thinking more in the direction of controlling it settings, maybe
even restricting check_interval and the CMCI poll interval, relative to
each other maybe, but still configurable with the max flexibility.

For that we'll need to answer questions like

* Which min value is sane?
* Do check_interval and CMCI poll interval need to be related at all?
* Which max value makes sense?
* What about check_interval, do we want to touch that too?
...

Just throwing out a bunch of questions, off the top of my head, to get
some opinions/rants, etc.

> I'm not entirely sure. At some point, it ended up that way, and it
> broke in non-obvious ways, so we wanted to fix it.

Right, so if we restrict it, the fix is even simpler. Unless you have a
more valid use than "[a]t some point, it ended up that way... " :-)

> We will definitely take a look, thanks. Looks interesting, though it's
> not always obvious what works for us until we actually go and try it.

Cool, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
