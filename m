Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab3BMVoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab3BMVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:44:45 -0500
From: Tom Tromey <tromey@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Ben Widawsky <ben@bwidawsk.net>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v5 01/20] scripts/gdb: Add infrastructure
References: <cover.1359463075.git.jan.kiszka@siemens.com>
	<cover.1359463075.git.jan.kiszka@siemens.com>
	<99da3a9930c678555d260206688158441d2bab05.1359463075.git.jan.kiszka@siemens.com>
X-Attribution: Tom
Date: Wed, 13 Feb 2013 14:43:37 -0700
In-Reply-To: <99da3a9930c678555d260206688158441d2bab05.1359463075.git.jan.kiszka@siemens.com>
	(Jan Kiszka's message of "Tue, 29 Jan 2013 13:37:44 +0100")
Message-ID: <87liarkhyu.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Kiszka <jan.kiszka@siemens.com> writes:

Jan> +if gdb_version < "7.1":
Jan> +	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
Jan> +	      "to work."

FWIW you can just directly feature-test for the things you know you need.
Like:  if not hasattr(gdb, 'parse_and_eval'): ...
In this case, 7.1 is old enough that it probably doesn't matter.
For newer things, though, it is better to feature-test because distros
sometimes forward-port patches, so the version number isn't a reliable
indicator.

Tom
