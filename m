Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844Ab3BMVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:38:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3BMVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:38:58 -0500
From: Tom Tromey <tromey@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Ben Widawsky <ben@bwidawsk.net>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 13/20] scripts/gdb: Add is_target_arch helper
References: <cover.1359463075.git.jan.kiszka@siemens.com>
	<cover.1359463075.git.jan.kiszka@siemens.com>
	<ee9f53440ebd93d76655345881d70f4f5b481b19.1359463075.git.jan.kiszka@siemens.com>
X-Attribution: Tom
Date: Wed, 13 Feb 2013 14:38:28 -0700
In-Reply-To: <ee9f53440ebd93d76655345881d70f4f5b481b19.1359463075.git.jan.kiszka@siemens.com>
	(Jan Kiszka's message of "Tue, 29 Jan 2013 13:37:56 +0100")
Message-ID: <87pq03ki7f.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Kiszka <jan.kiszka@siemens.com> writes:

Jan> +def is_target_arch(arch):
Jan> +	global target_arch
Jan> +	if target_arch == None:
Jan> +		target_arch = gdb.execute("show architecture", False, True)
Jan> +	return target_arch.find(arch) >= 0

FYI - the next gdb will have a Frame.architecture method for getting the
architecture of a frame.  You might consider using it when it is
available.  "show architecture" is mildly unfortunate to cache given its
"auto" behavior.

Tom
