Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaEMQsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:48:35 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64312 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaEMQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:48:27 -0400
Date: Tue, 13 May 2014 18:48:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Damien Lespiau <damien.lespiau@intel.com>
Cc: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140513164820.GQ3908@phenom.ffwll.local>
Mail-Followup-To: Damien Lespiau <damien.lespiau@intel.com>,
	=?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
 <CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
 <CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
 <20140512190300.GF25056@phenom.ffwll.local>
 <CADDKRnAOkdaziCQ_NGkt01hiQqjiAiKza2+QbCuDBuY72LJK=A@mail.gmail.com>
 <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
 <20140513132200.GC3908@phenom.ffwll.local>
 <CADDKRnADucv7wMRgEDZ_DKRJqkPPZdgymL6VJhtG_JD9MkiJhA@mail.gmail.com>
 <20140513163832.GM3908@phenom.ffwll.local>
 <20140513164631.GA16632@strange.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513164631.GA16632@strange.amr.corp.intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:46:31PM +0100, Damien Lespiau wrote:
> On Tue, May 13, 2014 at 06:38:32PM +0200, Daniel Vetter wrote:
> > > Doesn't work for me, I still have an underrun at boot-up.
> > 
> > I'm at a loss tbh with ideas. We successfully disable both pipes, then
> > enable pipe A and it all works.
> > 
> > Then we enable pipe B and _both_ pipes underrun immediately afterwards.
> > Really strange. Can you please reproduce the issue again on
> > drm-intel-nightly (latest -nightly should also have the display
> > corruptions fixed, so good to retest anyway) and attach a new dmesg with
> > drm.debug=0xe.
> > 
> > Meanwhile I'll try to come up with new theories and ideas.
> 
> I do remember a reporter saying a BIOS upgrade fixed that for him. This
> is one of the reasons Paulo put that BIOS update message.
> 
> It's worth the try if you ask me (the BIOS update will bring new memory
> latency values).

The fifo underrun code should be able to cope with bios stupidity - that's
why we don't enable it on takeover. Apparently there's a bug in that logic
somewhere.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
