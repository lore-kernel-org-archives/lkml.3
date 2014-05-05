Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbaEEOwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:52:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaEEOw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:52:28 -0400
Message-ID: <5367A5AA.5070502@suse.cz>
Date: Mon, 05 May 2014 16:52:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/5] firmware: Simplify directory creation
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz> <1398780493-15391-2-git-send-email-mmarek@suse.cz> <20140430161204.GA15320@ravnborg.org>
In-Reply-To: <20140430161204.GA15320@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-30 18:12, Sam Ravnborg wrote:
> On Tue, Apr 29, 2014 at 04:08:09PM +0200, Michal Marek wrote:
>> When building the firmware blobs, use a simple loop to create
>> directories in $(objtree), like in Makefile.build. This simplifies the
>> rules and also makes it possible to set $(objtree) to '.' later. Before
>> this change, a dependency on $(objtree)/<dir> would be satisfied by
>> <dir> in $(srctree).
>>
>> When installing the firmware blobs, call mkdir like in Makefile.modinst.
>>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> Hi Michal.
> 
> The patch looks good. I di not stare enough to fully grasp it,
> but it is a nice cleanup.

Previously, there were make rules for

$(objtree)/firmware/<dir>

to create each <dir> under firmware. If we change $(objtree) to '.', the
rule becomes ./firmware/<dir>, but since there already is
$(srctree)/firmware/<dir> and VPATH is set to $(srctree), the rule will
be satisfied by the directory in the $(srctree) and no directory in
$(objtree) will be created. So I changed it to create the directories
unconditionally when parsing the Makefile, just like
scripts/Makefile.build does it.

Michal

