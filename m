Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaJVN0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:26:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:15537 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbaJVN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:26:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,769,1406617200"; 
   d="scan'208";a="593752265"
From: Jani Nikula <jani.nikula@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression: checkpatch.pl fails when called via symlink
In-Reply-To: <1413980418.18654.8.camel@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <874muwv0ym.fsf@intel.com> <1413980418.18654.8.camel@perches.com>
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 16:25:28 +0300
Message-ID: <87ppdktewn.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-10-22 at 13:43 +0300, Jani Nikula wrote:
>> Since commit 66b47b4a9dad00e45c049d79966de9a3a1f4d337
>> Author: Kees Cook <keescook@chromium.org>
>> Date:   Mon Oct 13 15:51:57 2014 -0700
>> 
>>     checkpatch: look for common misspellings
>> 
>> checkpatch.pl dies with
>> 
>> checkpatch.pl: Can't open /path/to/spelling.txt for reading: No such file or directory
>> 
>> if it's called through a symlink in /path/to/checkpatch.pl pointing at
>> the actual script.
>> 
>> Please fail graciously, and just ignore spelling if you can't find
>> spelling.txt. Or better yet, follow the links if you can.
>
> I agree it should fail better, but I'm also curious.
> Why you want to use a symlink?

Simply because I think having $HOME/bin in $PATH and a symlink there is
better than the alternatives.

I don't want to add scripts to $PATH because there's so much cruft. I
don't want to copy checkpatch.pl (and now spelling.txt) because I
generally want it to stay up-to-date. I don't want to use an alias
because some maintainer scripts would break. I don't want to use a full
path because it's tedious, and potentially different on different
machines.

Reference: http://xkcd.com/1172/


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
