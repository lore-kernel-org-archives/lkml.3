Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbaJ2WUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:20:23 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60188 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaJ2WUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:20:22 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 29 Oct 2014 15:20:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
Message-ID: <20141029222015.GA17755@jtriplet-mobl1>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
 <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:12:49PM +0100, Geert Uytterhoeven wrote:
> On Wed, Oct 29, 2014 at 7:15 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > Document several common practices and conventions regarding conditional
> > compilation, most notably the preference for ifdefs in headers rather
> > than .c files.
> >
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> > +If you have a function or variable which may potentially go unused in a
> > +particular configuration, and the compiler would warn about its definition
> > +going unused, mark the definition as __maybe_unused rather than wrapping it in
> > +a preprocessor conditional.  (However, if a function or variable *always* goes
> > +unused, delete it.)
> 
> Personally, I don't like __maybe_unused. Once it's there, the compiler
> will stop warning about it, even if it really becomes unused.

True.  It's a tradeoff between getting the compiler to warn about unused
code to allow removing it, and putting #ifdefs in .c files.  However,
in previous patch discussions, developers seem to come down pretty
consistently on the side of "don't put #ifdefs in .c files".

> Apart from that:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

- Josh Triplett
