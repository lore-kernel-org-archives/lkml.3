Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbaJ3CYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:24:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41267 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbaJ3CYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:24:20 -0400
X-Originating-IP: 50.43.41.112
Date: Wed, 29 Oct 2014 19:24:11 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
Message-ID: <20141030022411.GA28982@thin>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
 <CAMuHMdV2Z0+gon8+LP_7X2h4B4Hb3KAV2vpZ9kRwC2mVFGLWXw@mail.gmail.com>
 <545187B6.1090704@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545187B6.1090704@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:35:02PM -0700, Randy Dunlap wrote:
> On 10/29/14 12:12, Geert Uytterhoeven wrote:
> > On Wed, Oct 29, 2014 at 7:15 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> >> Document several common practices and conventions regarding conditional
> >> compilation, most notably the preference for ifdefs in headers rather
> >> than .c files.
> >>
> >> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > 
> >> +If you have a function or variable which may potentially go unused in a
> >> +particular configuration, and the compiler would warn about its definition
> >> +going unused, mark the definition as __maybe_unused rather than wrapping it in
> >> +a preprocessor conditional.  (However, if a function or variable *always* goes
> >> +unused, delete it.)
> > 
> > Personally, I don't like __maybe_unused. Once it's there, the compiler
> > will stop warning about it, even if it really becomes unused.
> > 
> > Apart from that:
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Is the compiler smart enough to delete (discard) the code or data instance
> if it is unused or is the code or data actually wasting space?

If you mark a function or variable as __maybe_unused, and it actually
goes unused, the compiler will silently discard it.

- Josh Triplett
