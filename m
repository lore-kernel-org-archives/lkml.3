Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615AbaGPSmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:42:12 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57166 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934741AbaGPSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:42:07 -0400
Message-ID: <1405536124.4357.17.camel@x41>
Subject: Re: [PATCH] fs/direct-io.c: Fix compilation warning for
 uninitialized variables
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        Boaz Harrosh <openosd@gmail.com>, pramod.gurav.etc@gmail.com,
        viro@zeniv.linux.org.uk, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 20:42:04 +0200
In-Reply-To: <20140716175803.GA3631@infradead.org>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
	 <20140713115022.GA6054@infradead.org> <53C6B199.2070606@gmail.com>
	 <20140716175803.GA3631@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 18:42:04.0789 (UTC) FILETIME=[A39D4A50:01CFA125]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Borislav and Sam to cc.]

Christoph Hellwig schreef op wo 16-07-2014 om 10:58 [-0700]:
> On Wed, Jul 16, 2014 at 08:08:41PM +0300, Boaz Harrosh wrote:
> > This is the wrong fix. GCC is wrong here. As shown by Paul Bolle if
> > you move the from / to set from dio_get_page() to here the warning goes away.
> > 
> > The minimal fix must use uninitialized_var() in this case. See patch below
> > 
> > But I think the proper fix Is the one Paul Bolle <pebolle@tiscali.nl> sent (above)
> 
> I don't think the initialization is wrong.  The fix of moving the code
> defintively looks nicer,

Whether that was Jason's idea or mine doesn't matter much - though I do
think Boaz quoted part of my fix, but it was just a _draft_.

Anyhow, after all that I got involved in a short thread;
https://lkml.org/lkml/2014/7/8/168 is my contribution. My point is,
basically, that the false positives of -Wmaybe-uninitialized are a "code
smell". They tend to disappear if one reorganizes the code a bit.
Borislav disagrees quite strongly. I didn't really bother with keeping
that thread alive because I feared we'd mainly see more colorful
language.

>  while I think uninitialized_var is horrible wart

Agree totally.

>  that won't get anywhere near my code.
>
> Either way we should merge one of those fixes ASAP..

I'd like my builds to be warning free too. And it would be nice to know
whether there's consensus on how to deal with the false positives of
-Wmaybe-uninitialized that make it into mainline.


Paul Bolle

