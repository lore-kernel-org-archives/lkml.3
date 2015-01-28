Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbA2Eej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:34:39 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53715 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbA2Eei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:34:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4] trace: Use 64-bit timekeeping
Date: Wed, 28 Jan 2015 15:55:39 +0100
Message-ID: <13699348.kjuUqHkb9Z@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150128095349.6a3537a2@gandalf.local.home>
References: <20150128141611.GA2701@tinar> <20150128095349.6a3537a2@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:t9n+956CeQDS3bbJmWVANhVMLcSK1ft9euBugyt/BKcmeahO86E
 4+8BSqjk4YgdGIP/lXJi/sRcWk7eifKkwidF3Ew6wwg1dzJTNeQ6Ewj3cgngO2qz7z8TSyL
 zX9xYfm6J1W73bp5DWH9OMAoBBUcibHpFTYY37L3z8V/CkgM8K1bmE07DZKuos91s5CfXPZ
 zelc+Da+ff5v6PqjhjtVw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 09:53:49 Steven Rostedt wrote:
> On Wed, 28 Jan 2015 19:46:11 +0530
> Tina Ruchandani <ruchandani.tina@gmail.com> wrote:
> 
> > The ring_buffer_producer uses 'struct timeval' to measure
> > its start and end times. 'struct timeval' on 32-bit systems
> > will have its tv_sec value overflow in year 2038 and beyond.
> > This patch replaces struct timeval with 'ktime_t' which uses
> > 64-bit representation for nanoseconds.
> > 
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> > ---
> > Changes in v4:
> >       - Fix typo in commit message.
> >       - Avoid typecast to 'long long' by defining RUN_TIME as '10ULL'
> >         instead of '10'.
> 
> Although I have not tested this, this patch looks fine to me. Is this
> going to go through some cleanup tree or should I just pull it?
> 

Please apply it to your tree.

	Arnd
