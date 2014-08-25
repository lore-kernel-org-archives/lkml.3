Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbaHYWCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:02:32 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49971 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaHYWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:02:30 -0400
Date: Mon, 25 Aug 2014 15:00:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Hugh Dickins <hughd@google.com>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
In-Reply-To: <20140825213752.GD3070@type.youpi.perso.aquilenet.fr>
Message-ID: <alpine.LSU.2.11.1408251454570.26438@eggly.anvils>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils> <10857.1408467967@turing-police.cc.vt.edu> <20140825211340.GA22168@kria> <20140825212324.GC3070@type.youpi.perso.aquilenet.fr> <20140825213752.GD3070@type.youpi.perso.aquilenet.fr>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1686296495-1409004052=:26438"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1686296495-1409004052=:26438
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 25 Aug 2014, Samuel Thibault wrote:
> Samuel Thibault, le Mon 25 Aug 2014 23:23:24 +0200, a =E9crit :
> > We could indeed have a loop if the user was making the VT::* leds use
> > the vt-* trigger,
>=20
> Actually, while there can be a loop, it wouldn't be possible to inject
> events in it: a VT::* led only makes the corresponding vt-* trigger if
> it got an event from its trigger, etc. So it's really a false positive,
> the lock detector just can not know that it can not happen.

I'm not suffering from this lockdep warning myself; but, false positive
or not, it does need to be fixed (or annotated).  Because once lockdep
reports one issue, it turns itself off.  So any developer who hits this
warning is then unable test their own changes with lockdep afterwards.

Hugh
--0-1686296495-1409004052=:26438--
