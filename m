Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbaHYXe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:34:57 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:44516 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaHYXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:34:55 -0400
Date: Tue, 26 Aug 2014 01:34:43 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Hugh Dickins <hughd@google.com>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Message-ID: <20140825233443.GB13130@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Hugh Dickins <hughd@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
	Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <10857.1408467967@turing-police.cc.vt.edu>
 <20140825211340.GA22168@kria>
 <20140825212324.GC3070@type.youpi.perso.aquilenet.fr>
 <20140825213752.GD3070@type.youpi.perso.aquilenet.fr>
 <alpine.LSU.2.11.1408251454570.26438@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.11.1408251454570.26438@eggly.anvils>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins, le Mon 25 Aug 2014 15:00:44 -0700, a écrit :
> On Mon, 25 Aug 2014, Samuel Thibault wrote:
> > Samuel Thibault, le Mon 25 Aug 2014 23:23:24 +0200, a écrit :
> > > We could indeed have a loop if the user was making the VT::* leds use
> > > the vt-* trigger,
> > 
> > Actually, while there can be a loop, it wouldn't be possible to inject
> > events in it: a VT::* led only makes the corresponding vt-* trigger if
> > it got an event from its trigger, etc. So it's really a false positive,
> > the lock detector just can not know that it can not happen.
> 
> I'm not suffering from this lockdep warning myself; but, false positive
> or not, it does need to be fixed (or annotated).  Because once lockdep
> reports one issue, it turns itself off.  So any developer who hits this
> warning is then unable test their own changes with lockdep afterwards.

Ew. I'll have a look.

Samuel
