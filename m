Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3HCW2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:28:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54310 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3HCW2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:28:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Sun, 04 Aug 2013 00:38:53 +0200
Message-ID: <5977534.o64DLE8ToP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s3kacF57gsJzyL6-4JWfWpdfJbJYW-nWQ92Yn1VimnYug@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <2483450.yz2brWbP8X@vostro.rjw.lan> <CAMP44s3kacF57gsJzyL6-4JWfWpdfJbJYW-nWQ92Yn1VimnYug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 05:20:33 PM Felipe Contreras wrote:
> On Sat, Aug 3, 2013 at 4:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, August 03, 2013 03:24:16 PM Felipe Contreras wrote:
> >> On Sat, Aug 3, 2013 at 6:34 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
> >>
> >> >> Yes, the patch is correct, but I still prefer my own version :-)
> >> >> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
> >> >>
> >> >> In case you want to take mine and mine needs refresh, please let me know
> >> >> and I can do the re-base, thanks.
> >> >
> >> > Well, I prefer simpler, unless there's a good reason to use more complicated.
> >>
> >> Note that these are not exclusionary; his patch can be applied on top
> >> of mine. I don't think his patch is needed though.
> >
> > OK
> >
> > Do we still need to revert commit efaa14c if this patch is applied?
> 
> I guess not. At least in this machine changing the backlight works
> correctly, whereas in v3.11-rc3 it was all weird, and v3.7-v3.10
> didn't work at all. I cannot see how it would affect negatively other
> machines.
> 
> That being said, the blacklisting is still needed, because 1. the
> level is not preserved between boots, and 2. level 0 turns off the
> screen, which I personally consider a regression.
> 
> At least it boots to level 100 instead of 0.

OK

I'll push this patch to Linus for -rc5 then without the revert of commit
commit efaa14c.  That's all I'm going to do for 3.11 in the ACPI video
area at this point.

As far as the blacklisting is concerned, I still have the blacklist of
your Asus machine queued up for 3.12.  Since you're claiming that it
doesn't have any side effects on that machine, I think I can apply it.

However, for other machines to be added to that blacklist I need to see
requests from their users with confirmation that there are no visible side
effects there.

I think this is fair enough.

Thanks,
Rafael

