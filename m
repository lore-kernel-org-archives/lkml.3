Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaEaO4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:56:31 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51257 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaEaO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:56:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
Date: Sat, 31 May 2014 16:54:41 +0200
Message-ID: <5507335.AOOTyGEum3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <m2tx86l4ux.fsf@linux-m68k.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <CAMuHMdVgch4REGcYWFZXVToX2b8iCinFVV10Bz3VoeiZy_yBtg@mail.gmail.com> <m2tx86l4ux.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fKI/Q5UFf0LcWA8puJCKAJBdDdtqzNgyPT5lmrEfZ1a
 mmNDkOWnhRQEjwuPfPYkJwmYznwgC3AfxuZwUfAjgyb+47d/mM
 Com+gnru5UpxTSSzpTcg5hWV33PDCncFrWAoQPf4c0GNPDUuCp
 KyLM3HGyaICRhg8mOrXOEKMdkzl1JU19Dup3ckRe7/cWTlUy02
 96ZSyiXGjlZT+CdLNI5q+CKySF0kJ2+avDgh64dugnBBe9az1G
 Qn4v7QD21MTKybwxQvyOzRmBtB+1afY4A4aGE2WQl0pmlXcAJ9
 QaT99Uw56j/ndKEOIYwhrpz7YlhUU5s6JS4zCLrmeTa9PzlD5s
 Byja+5O1p7qm2UXU83Z0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 10:39:02 Andreas Schwab wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> 
> > Hi Arnd,
> >
> > On Fri, May 30, 2014 at 10:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> + * The variant using bit fields is less efficient to access, but
> >> + * small and has a wider range as the 32-bit one, plus it keeps
> >> + * the signedness of the original timespec.
> >> + */
> >> +struct inode_time {
> >> +       long long       tv_sec  : 34;
> >> +       int             tv_nsec : 30;
> >> +};
> >
> > Don't you need 31 bits for tv_nsec, to accommodate for the sign bit?
> > I know you won't really store negative numbers there, but storing a large
> > positive number will become negative on read out, won't it?
> 
> Only if the int bitfield is signed.  Bitfields are weird, aren't they? 

It was a mistake on my side, as I didn't know about that rule and
meant write 'unsigned int' really. Also, I always have a bad feeling
about using bitfields in general.

	Arnd
