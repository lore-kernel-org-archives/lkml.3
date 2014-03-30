Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaC3W5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 18:57:18 -0400
Received: from mail.tomasu.net ([192.241.222.217]:46144 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbaC3W5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 18:57:17 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: Marc Burkhardt <marc@marc.ngoe.de>
Reply-To: thomas@fjellstrom.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: turbo on lenovo w530 causing over-temp warnings
Date: Sun, 30 Mar 2014 16:57:15 -0600
Message-ID: <4819075.C0MTBkDfgh@balsa>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7286ed3d-6e07-4276-9f43-1b51eca23d18@email.android.com>
References: <2113542.FNB0FtJayJ@balsa> <7286ed3d-6e07-4276-9f43-1b51eca23d18@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just installed mcelog, if it'll help me figure out what is going on I'll 
try it. But the actual reboots come from an actual thermal alert, I've seen 
them appear in the console just before the machine shuts off. It seems at 
around 100-110c, something (lmsensors? Kernel?) will 'shutdown -h now', which 
totally makes sense. What doesn't make sense is why is it even reaching that 
temperature to begin with.

I was under the impression that the intel Turbo tech automatically (ie: in 
cpu) throttle back to a lower boost clock when certain thermal targets are 
hit. It doesn't seem to be doing that very well. At best it limits all 4 cores 
to 3.4Ghz, instead of occasionally hitting 3.6Ghz. Even 3.4Ghz is way too high 
when all 4 cores are pegged.

On Sun 30 Mar 2014 12:45:32 PM Marc Burkhardt wrote:
> Have you configured to catch 'Machine Check Exceptions' / MCE?
> 
> Regards,
> Marc
> 
> On 30. März 2014 11:13:57 MESZ, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> >I have a lenovo w530 laptop with an intel i7-3720QM processor, and when
> >
> >running something with high cpu use causes the cpu to be put into the
> >highest
> >turbo mode and stays there as long as the core is being used. It
> >doesn't scale
> >back to the real max frequency once temperatures rise.
> >
> >I've had my laptop shut itself down after a few minutes due to a
> >thermal
> >warning a few times. I was attempting to try the latest stable stock
> >(non
> >debian) kernel to see if maybe it was a weird distro config issue (it
> >happens),
> >but as I was compiling the kernel, CPU temps hit 90c, and were climbing
> >after
> >only a few minutes. If I had let it go longer, I am 100% sure it would
> >have
> >shut itself off again.
> >
> >I just tried seeing what would happen if I just ran a straight up make
> >on the
> >kernel with no -j option. So only one core at a time would be pegged,
> >and it
> >caused all 4 cores to spike to 3.4Ghz+ and stay there till I killed the
> >job.
> >
> >Is this a known problem? Is there something obvious I've missed?
> >
> >I've been trying to find relevant info online about this, but a lot of
> >it is
> >fairly old and references the intel_pstep driver causing tubo to be
> >stuck on
> >100% of the time. In my case its only stuck at full turbo while there
> >is a
> >certain amount of cpu use. It does drop back if nothing is running.
> >
> >Currently running kernel is the debian 3.13.7-1 kernel from sid. I will
> >
> >attempt to try the stock latest stable, as well as the latest rc, but I
> >won't
> >be able to get around to both till tomorrow.
> >
> >Thanks.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
