Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaCDSUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:20:46 -0500
Received: from mailscanner02.zoner.fi ([84.34.166.11]:47115 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:20:45 -0500
Date: Tue, 4 Mar 2014 20:20:38 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kyle McMartin <kyle@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
Message-ID: <20140304202038.03b36109@tukaani.org>
In-Reply-To: <CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
References: <20140228230017.GE14970@merlin.infradead.org>
	<20140303145137.70819698@tukaani.org>
	<CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-03 Florian Fainelli wrote:
> 2014-03-03 4:51 GMT-08:00 Lasse Collin <lasse.collin@tukaani.org>:
> > The second version enables the BCJ filter only for the current arch
> > by default if CONFIG_EXPERT; without CONFIG_EXPERT all filters are
> > forced on:
> 
> I like this version better because it still provides you with accurate
> defaults (i.e: enable only th X86 BCJ filter decoder where it makes
> sense by default) and still provides enough flexibility.

I understand your viewpoint, but different people probably consider
different options as "accurate defaults". The current behavior certainly
isn't very accurate; otherwise Kyle McMartin wouldn't have had a reason
to send a patch. The patch you prefer would give both of you the
defaults you want *if* embedded devs always use CONFIG_EXPERT and
non-embedded people never do. If a non-embedded dev uses CONFIG_EXPERT,
then Kyle's problem can reappear.

I still think it is clearest to enable all by default and allow
deselecting filters if CONFIG_EXPERT. That way the default selection
doesn't change behind anyone's back when CONFIG_EXPERT is selected.
I guess embedded devs go through the config carefully looking for
things to deselect anyway, but maybe it was easy to miss these options
just like some desktop users have missed them now.

I'd like to make the defaults such that minimum number of people get
annoyed in the long term. There will always be people who will need to
change the options (otherwise options wouldn't be needed). At the same
time this is so very tiny issue that I don't expect many people to care
at all.

I'll submit some patch this week but I'll wait for more opinions for a
day or two. Thanks.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
