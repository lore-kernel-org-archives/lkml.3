Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3FYIKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:10:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41497 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3FYIKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:10:45 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201306251001.12430.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	<8357b48549e17b3e4e402c7f977b65708922e60f.1372097219.git.yann.morin.1998@free.fr>
	<201306251001.12430.yann.morin.1998@free.fr>
Date: Tue, 25 Jun 2013 10:10:44 +0200
Message-ID: <CA+icZUW69zkZice9K4Q2Fr=nuC3KCOr2ZXRZFymYadsxCvB1tA@mail.gmail.com>
Subject: Re: [PATCH 15/15] kconfig: fix randomising choice entries in presence
 of KCONFIG_ALLCONFIG
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Kriegisch <Alexander@kriegisch.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:01 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> Michal, All,
>
> On Monday 24 June 2013 20:11:59 Yann E. MORIN wrote:
>> Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
>> is specified.
> [--SNIP--]
>> This patch defers setting that a choice has a value until a symbol for
>> that choice is indeed set, so that choices are properly randomised when
>> KCONFIG_ALLCONFIG is set, but not if a symbol for that choice is set.
>
> I've just been informed by Fengguang that this patch breaks yet another
> use-case of his, but this time KCONFIG_ALLCONFIG is not involved.
>
> I'll investigate this issue when I'm back home tonight (ie. ~16:00 UTC).
> Sorry for the breakage (again...). :-(
>
> We really need a known, shared test-suite for kconfig... :-/
>

[ CC Alexander ]

A-propos, "testing Kconfig" I recommended to take into account the
script of Alexander.
In PM we discussed on where to place such scripts and that Alexander's
patch needs some refreshing in your eyes.
Maybe, Alexander can/will help as he is the original author.
As said, this script helped in the Freetz router project to eliminate
dozens of (logically) wrong Kconfig settings.
IMHO there exist a lot of more, as there are "double/triple" checks in
the Freetz-buildsystem, but hey noone is perfect :-).

- Sedat -

[1] http://freetz.org/browser/trunk/tools/developer/create-kconfig-warnings

> Regards,
> Yann E. MORIN.
>
> --
> .-----------------.--------------------.------------------.--------------------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
> | +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
> | --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
> | http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
> '------------------------------'-------'------------------'--------------------'
