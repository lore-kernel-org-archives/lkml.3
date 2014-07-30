Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaG3NuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:50:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaG3NuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:50:16 -0400
Message-ID: <53D8F816.7040104@suse.cz>
Date: Wed, 30 Jul 2014 15:50:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dirk Gouders <dirk@gouders.net>
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v4
References: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-30 01:11, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This is an alternative approach to lower the overhead of debug info
> (as we discussed a few days ago)
> 
> gcc 4.7+ and newer binutils have a new "split debug info" debug info
> model where the debug info is only written once into central ".dwo" files.
> 
> This avoids having to copy it around multiple times, from the object
> files to the final executable. It lowers the disk space
> requirements. In addition it defaults to compressed debug data.
> 
> More details here: http://gcc.gnu.org/wiki/DebugFission
> 
> This patch adds a new option to enable it. It has to be an option,
> because it'll undoubtedly break everyone's debuginfo packaging scheme.
> gdb/objdump/etc. all still work, if you have new enough versions.
> 
> I don't see big compile wins (maybe a second or two faster or so), but the
> object dirs with debuginfo get significantly smaller. My standard kernel
> config (slightly bigger than defconfig) shrinks from 2.9G disk space
> to 1.1G objdir (with non reduced debuginfo). I presume if you are IO limited
> the compile time difference will be larger.
> 
> Only problem I've seen so far is that it doesn't play well with older
> versions of ccache (apparently fixed, see
> https://bugzilla.samba.org/show_bug.cgi?id=10005)

The failure mode with ccache is that the *.dwo files are not stored, but
the build proceeds, right? This is at least what I'm seeing. I'm just
wondering if the config option should be inverted to make
all{yes,mod}config builds happy. But it's probably not necessary if the
build passes.

Thanks,
Michal
